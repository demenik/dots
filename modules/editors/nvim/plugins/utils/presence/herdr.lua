-- Gates cord.nvim presence on herdr state: shown only while a herdr client is
-- attached and this pane's workspace is focused
local M = {}

local uv = vim.uv

local POLL_MS = 3000
local POLL_MULTI_MS = 1000
local RECONNECT_MS = 5000

local sock = os.getenv("HERDR_SOCKET_PATH") or ""
local state = {
  pane = os.getenv("HERDR_PANE_ID"),
  ws = os.getenv("HERDR_WORKSPACE_ID"),
  ws_focused = true,
  clients = 1,
  -- ws_focused before a second client attached; herdr's focus is global across
  -- clients and does not revert when one detaches, so it is restored manually
  saved = nil,
  shown = nil,
  manager = nil,
}

local client_sock_entry
local poll_timer

local function apply()
  local m = state.manager
  if not m then
    return
  end

  local visible = state.ws_focused and state.clients > 0
  if visible == state.shown then
    return
  end
  state.shown = visible

  if visible then
    m:resume()
    m:queue_update(true)
  else
    m:suppress()
  end
end

--- Count attached clients via connections on herdr-client.sock (one line per
--- connection plus one for the listener)
local function count_clients()
  local f = io.open("/proc/net/unix", "r")
  if not f then
    return state.clients
  end
  local data = f:read("*a")
  f:close()
  local _, n = data:gsub(client_sock_entry, "")
  return math.max(n - 1, 0)
end

local function start_poll(interval)
  poll_timer:start(interval, interval, vim.schedule_wrap(M.poll))
end

function M.poll()
  local prev, n = state.clients, count_clients()
  if n == prev then
    return
  end

  if prev <= 1 and n > 1 then
    state.saved = state.ws_focused
    start_poll(POLL_MULTI_MS)
  elseif prev > 1 and n <= 1 then
    if state.saved ~= nil then
      state.ws_focused = state.saved
    end
    state.saved = nil
    start_poll(POLL_MS)
  end

  state.clients = n
  apply()
end

local function close(pipe)
  if not pipe:is_closing() then
    pipe:close()
  end
end

--- Read newline-delimited JSON messages from a pipe
local function read_lines(pipe, on_msg, on_eof)
  local buf = ""
  pipe:read_start(function(err, chunk)
    if err or not chunk then
      close(pipe)
      if on_eof then
        on_eof()
      end
      return
    end
    buf = buf .. chunk
    for line in buf:gmatch("([^\n]*)\n") do
      local ok, msg = pcall(vim.json.decode, line)
      if ok and type(msg) == "table" then
        vim.schedule(function()
          on_msg(msg, pipe)
        end)
      end
    end
    buf = buf:match("[^\n]*$")
  end)
end

--- Send one request over a fresh connection (herdr answers one per connection)
local function request(payload, on_msg, on_eof)
  local pipe = assert(uv.new_pipe(false))
  pipe:connect(sock, function(err)
    if err then
      close(pipe)
      if on_eof then
        on_eof()
      end
      return
    end
    pipe:write(vim.json.encode(payload) .. "\n")
    read_lines(pipe, on_msg, on_eof)
  end)
end

local function refresh_workspace()
  request({ id = "presence:ws", method = "workspace.get", params = { workspace_id = state.ws } }, function(msg, pipe)
    close(pipe)
    local info = msg.result and msg.result.workspace
    if info then
      state.ws_focused = info.focused
      apply()
    end
  end)
end

local function on_event(msg)
  local data = msg.data
  if not data then
    return
  end

  if data.type == "workspace_focused" then
    state.ws_focused = data.workspace_id == state.ws
    apply()
  elseif data.type == "pane_moved" and data.previous_pane_id == state.pane and data.pane then
    state.pane = data.pane.pane_id
    state.ws = data.pane.workspace_id
    refresh_workspace()
  end
end

local function subscribe()
  request(
    {
      id = "presence:sub",
      method = "events.subscribe",
      params = { subscriptions = { { type = "workspace.focused" }, { type = "pane.moved" } } },
    },
    on_event,
    function()
      -- Server stopped or handed off: retry, then resync the state
      vim.defer_fn(function()
        subscribe()
        refresh_workspace()
      end, RECONNECT_MS)
    end
  )
end

function M.setup()
  if os.getenv("HERDR_ENV") ~= "1" or not (state.pane and state.ws) then
    return
  end
  if not uv.fs_stat(sock) then
    return
  end

  client_sock_entry = vim.pesc(vim.fs.dirname(sock) .. "/herdr-client.sock") .. "\n"
  state.clients = count_clients()

  local group = vim.api.nvim_create_augroup("HerdrPresence", { clear = true })
  vim.api.nvim_create_autocmd("FocusGained", {
    group = group,
    callback = function()
      state.ws_focused = true
      M.poll()
      apply()
    end,
  })
  -- A detach of the last client only shows up as FocusLost, so recount quickly
  vim.api.nvim_create_autocmd("FocusLost", {
    group = group,
    callback = function()
      vim.defer_fn(M.poll, 150)
    end,
  })

  poll_timer = uv.new_timer()
  start_poll(state.clients > 1 and POLL_MULTI_MS or POLL_MS)

  subscribe()
  refresh_workspace()

  M.enabled = true
end

--- cord.nvim ready hook: runs before cord pushes its first activity
function M.attach(manager)
  if not M.enabled then
    return
  end
  state.manager = manager
  state.shown = nil
  apply()
end

return M
