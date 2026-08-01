local M = {}

local base_dir = vim.fn.expand("$HOME/dots/modules/editors/nvim/plugins/snippet")

local common_exts = {
  "nix",
  "lua",
  "py",
  "sh",
  "js",
  "ts",
  "jsx",
  "tsx",
  "html",
  "css",
  "json",
  "yaml",
  "toml",
  "md",
  "txt",
  "rs",
  "go",
  "c",
  "cpp",
  "h",
  "java",
  "kt",
  "cs",
}

--- Filetypes whose usual file extension is not just the filetype name.
local ft_extensions = {
  bash = "sh",
  csharp = "cs",
  gitcommit = "txt",
  javascript = "js",
  javascriptreact = "jsx",
  kotlin = "kt",
  markdown = "md",
  python = "py",
  rust = "rs",
  text = "txt",
  typescript = "ts",
  typescriptreact = "tsx",
  zsh = "sh",
}

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.INFO, { title = "Snippets" })
end

--- The extension a snippet taken from the current buffer most likely wants:
--- the current file's own extension, else one inferred from its filetype.
local function infer_extension()
  local ext = vim.fn.expand("%:e")
  if ext ~= "" then
    return ext
  end

  local ft = vim.bo.filetype
  if ft == "" then
    return "txt"
  end

  return ft_extensions[ft] or ft
end

--- Expand `~` and `$VAR` without also expanding shell wildcards.
local function expand_path(path)
  path = path:gsub("^~", vim.env.HOME or "~")
  path = path:gsub("%$([%w_]+)", function(name)
    return vim.env[name] or ("$" .. name)
  end)
  return (path:gsub("/+$", ""))
end

--- Normalize `path` to a base_dir-relative path, or nil if it escapes base_dir.
--- Returns "" for the base directory itself.
local function relative_path(path)
  if not path or path == "" then
    return nil
  end

  if path:sub(1, 1) == "/" then
    if path == base_dir then
      return ""
    end
    if path:sub(1, #base_dir + 1) ~= base_dir .. "/" then
      return nil
    end
    path = path:sub(#base_dir + 2)
  end

  local parts = {}
  for part in path:gmatch("[^/]+") do
    if part == ".." then
      return nil
    elseif part ~= "." then
      table.insert(parts, part)
    end
  end

  return table.concat(parts, "/")
end

--- Change the working directory, taking the file tree along with it.
---
--- nvim-tree only follows `DirChanged` when `sync_root_with_cwd` is enabled,
--- and turning that on would change its behaviour for every other `:cd` too,
--- so move its root directly instead.
local function set_cwd(path)
  local ok, err = pcall(vim.api.nvim_set_current_dir, path)
  if not ok then
    notify("Could not change directory to " .. path .. ": " .. tostring(err), vim.log.levels.ERROR)
    return
  end

  local has_tree, nvim_tree = pcall(require, "nvim-tree.api")
  if has_tree then
    pcall(nvim_tree.tree.change_root, path)
  end
end

--- Switch the working directory to the snippet tree, remembering where we came
--- from so `:SnippetExit` can put it back.
local function enter_snippet_mode()
  if not vim.g.snippet_mode then
    vim.g.snippet_prev_cwd = vim.fn.getcwd()
    vim.g.snippet_mode = true
  end
  set_cwd(base_dir)
end

--- Loaded buffers holding a file that really lives inside the snippet tree.
---
--- Deliberately stricter than `relative_path`, which accepts relative input
--- because command arguments are written that way. Buffer names are not paths:
--- a terminal is called `term://~/dev/test//447436:/bin/sh`, which is not
--- absolute and must never be mistaken for a snippet. Requiring an empty
--- `buftype` also keeps terminals, help and plugin buffers out.
local function snippet_buffers()
  local prefix = base_dir .. "/"
  local bufs = {}

  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == "" then
      local name = vim.api.nvim_buf_get_name(bufnr)
      if name:sub(1, #prefix) == prefix then
        table.insert(bufs, bufnr)
      end
    end
  end

  return bufs
end

--- nvim-tree reshapes windows on `BufEnter`, which Neovim forbids while a
--- buffer is being deleted (E1312). Suppress only the focus events that
--- trigger it; the tree is brought up to date by the `set_cwd` that follows.
local function close_buffers(bufs)
  local saved = vim.o.eventignore
  vim.o.eventignore = "BufEnter,BufWinEnter,WinEnter,BufLeave,WinLeave"

  local ok, err = pcall(function()
    for _, bufnr in ipairs(bufs) do
      if vim.api.nvim_buf_is_valid(bufnr) then
        vim.api.nvim_buf_delete(bufnr, {})
      end
    end
  end)

  vim.o.eventignore = saved

  if not ok then
    notify("Could not close snippet buffers: " .. tostring(err), vim.log.levels.ERROR)
  end
end

--- Enters snippet mode, but only once the buffer is actually on screen, so a
--- cancelled picker leaves the working directory alone.
---
--- Deferred because callers reach this from inside a picker action or a
--- `vim.ui.input` callback, where the prompt window is still being torn down
--- and window commands land in a buffer that is about to be discarded.
local function open(path)
  vim.schedule(function()
    local ok, err = pcall(vim.cmd, "edit " .. vim.fn.fnameescape(path))
    if not ok then
      ok, err = pcall(vim.cmd, "split " .. vim.fn.fnameescape(path))
    end

    if not ok then
      notify("Could not open " .. path .. ": " .. tostring(err), vim.log.levels.ERROR)
      return
    end

    enter_snippet_mode()
  end)
end

local function list_subdirs(lang)
  local uv = vim.uv or vim.loop
  local dirs = { "." }

  local function scan(dir, rel)
    local handle = uv.fs_scandir(dir)
    if not handle then
      return
    end

    while true do
      local name, entry_type = uv.fs_scandir_next(handle)
      if not name then
        break
      end

      if not name:match("^%.") then
        local full = dir .. "/" .. name
        if not entry_type then
          local stat = uv.fs_stat(full)
          entry_type = stat and stat.type
        end

        if entry_type == "directory" then
          local child = (rel == "") and name or (rel .. "/" .. name)
          table.insert(dirs, child)
          scan(full, child)
        end
      end
    end
  end

  scan(base_dir .. "/" .. lang, "")
  return dirs
end

--- Pick the first non-empty of the fzf selection and the typed query.
local function picked(selected, fallback)
  local query, choice = selected[1], selected[2]
  if choice and choice ~= "" then
    return choice
  end
  if query and query ~= "" then
    return query
  end
  return fallback
end

local function select_subdirectory(lang, callback)
  require("fzf-lua").fzf_exec(list_subdirs(lang), {
    prompt = "Subdirectory (or new name)> ",
    fzf_opts = { ["--print-query"] = true },
    actions = {
      ["default"] = function(selected)
        local choice = picked(selected, ".")
        local subdir = relative_path(choice)
        if not subdir then
          notify("Subdirectory must stay inside the snippet tree: " .. choice, vim.log.levels.ERROR)
          return
        end
        vim.schedule(function()
          callback(subdir)
        end)
      end,
    },
  })
end

--- `recommended` is listed first and highlighted; any other extension can still
--- be chosen, or a new one typed.
local function select_extension(recommended, callback)
  local fzf_lua = require("fzf-lua")
  local devicons = require("nvim-web-devicons")

  local exts = {}
  if recommended ~= "" then
    table.insert(exts, recommended)
  end
  for _, ext in ipairs(common_exts) do
    if ext ~= recommended then
      table.insert(exts, ext)
    end
  end

  local entries = {}
  local ext_of = {}
  for _, ext in ipairs(exts) do
    local icon = devicons.get_icon("file." .. ext, ext, { default = true })
    local label = "." .. ext
    if ext == recommended then
      label = fzf_lua.utils.ansi_codes.green(label .. "  (recommended)")
    end

    local entry = string.format("%s  %s", icon or " ", label)
    ext_of[fzf_lua.utils.strip_ansi_coloring(entry)] = ext
    table.insert(entries, entry)
  end

  fzf_lua.fzf_exec(entries, {
    prompt = "File Extension> ",
    fzf_opts = {
      ["--ansi"] = true,
      ["--print-query"] = true,
    },
    actions = {
      ["default"] = function(selected)
        local query, choice = selected[1], selected[2]

        local ext
        if choice and choice ~= "" then
          ext = ext_of[fzf_lua.utils.strip_ansi_coloring(choice)]
        end
        if not ext and query and query ~= "" then
          ext = query:gsub("^%.", ""):match("^[%w_%-]+")
        end
        if not ext or ext == "" then
          ext = (recommended ~= "") and recommended or "txt"
        end

        vim.schedule(function()
          callback(ext)
        end)
      end,
    },
  })
end

--- Write the current buffer to a new snippet template and open it.
function M.snippet_create()
  local lang = vim.bo.filetype
  if lang == nil or lang == "" then
    lang = "text"
  end

  local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
  local recommended_ext = infer_extension()

  select_subdirectory(lang, function(subdir)
    select_extension(recommended_ext, function(ext)
      vim.ui.input({ prompt = "Snippet trigger: " }, function(trigger)
        if not trigger or trigger == "" then
          return
        end
        if trigger:match("[/\\]") then
          notify("Trigger must not contain a path separator", vim.log.levels.ERROR)
          return
        end

        -- Deferred so the prompt window is gone before we touch the filesystem
        -- and start asking questions of our own.
        vim.schedule(function()
          local filename = trigger .. "." .. ext
          local target_dir = base_dir .. "/" .. lang
          if subdir ~= "" then
            target_dir = target_dir .. "/" .. subdir
          end
          local target_file = target_dir .. "/" .. filename

          local uv = vim.uv or vim.loop
          if uv.fs_stat(target_file) then
            local answer = vim.fn.confirm(filename .. " already exists. Overwrite it?", "&Yes\n&No", 2)
            if answer ~= 1 then
              return
            end
          end

          local made_dir, mkdir_result = pcall(vim.fn.mkdir, target_dir, "p")
          if not made_dir or mkdir_result == 0 then
            notify("Could not create " .. target_dir, vim.log.levels.ERROR)
            return
          end

          if vim.fn.writefile(lines, target_file) ~= 0 then
            notify("Could not write " .. target_file, vim.log.levels.ERROR)
            return
          end

          open(target_file)
          notify(("Wrote %s — add it to %s/default.nix to load it"):format(filename, target_dir))
        end)
      end)
    end)
  end)
end

function M.snippet_edit(path)
  if path and path ~= "" then
    local rel = relative_path(path)
    if not rel or rel == "" then
      notify("Not a snippet path: " .. path, vim.log.levels.ERROR)
      return
    end

    local target = base_dir .. "/" .. rel
    if not (vim.uv or vim.loop).fs_stat(target) then
      notify("No such snippet: " .. rel, vim.log.levels.ERROR)
      return
    end

    open(target)
    return
  end

  local fzf_lua = require("fzf-lua")
  fzf_lua.files({
    cwd = base_dir,
    prompt = "Edit Snippet> ",
    actions = {
      ["default"] = function(selected, opts)
        if not selected or not selected[1] then
          return
        end
        local entry = require("fzf-lua.path").entry_to_file(selected[1], opts or { cwd = base_dir })
        if entry and entry.path and entry.path ~= "" then
          open(entry.path)
        end
      end,
    },
  })
end

--- Close the snippet buffers and return to the working directory we started in.
function M.snippet_exit()
  if not vim.g.snippet_mode then
    notify("Not in snippet mode", vim.log.levels.WARN)
    return
  end

  local bufs = snippet_buffers()

  local unsaved = {}
  for _, bufnr in ipairs(bufs) do
    if vim.bo[bufnr].modified then
      table.insert(unsaved, vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t"))
    end
  end

  if #unsaved > 0 then
    notify("Save or discard first: " .. table.concat(unsaved, ", "), vim.log.levels.ERROR)
    return
  end

  close_buffers(bufs)

  local previous = vim.g.snippet_prev_cwd
  vim.g.snippet_mode = false
  vim.g.snippet_prev_cwd = nil

  if previous and previous ~= "" then
    set_cwd(previous)
  end

  notify("Exited snippet mode")
end

--- Complete snippet templates: everything nested under a language directory,
--- minus the `default.nix` files that declare them.
local function complete_snippets(arglead)
  local results = {}

  for _, file in ipairs(vim.fn.globpath(base_dir, "**/*", false, true)) do
    if vim.fn.isdirectory(file) == 0 then
      local rel = file:sub(#base_dir + 2)
      local name = vim.fn.fnamemodify(rel, ":t")
      if rel:find("/") and name ~= "default.nix" and rel:sub(1, #arglead) == arglead then
        table.insert(results, rel)
      end
    end
  end

  table.sort(results)
  return results
end

function M.setup(opts)
  opts = opts or {}
  if opts.base_dir and opts.base_dir ~= "" then
    base_dir = expand_path(opts.base_dir)
  end

  vim.api.nvim_create_user_command("SnippetCreate", function()
    M.snippet_create()
  end, { desc = "Write the current buffer to a new snippet template" })

  vim.api.nvim_create_user_command("SnippetEdit", function(args)
    M.snippet_edit(args.args)
  end, {
    nargs = "?",
    complete = complete_snippets,
    desc = "Open an existing snippet template",
  })

  vim.api.nvim_create_user_command("SnippetExit", function()
    M.snippet_exit()
  end, { desc = "Close the snippet buffers and restore the working directory" })
end

return M
