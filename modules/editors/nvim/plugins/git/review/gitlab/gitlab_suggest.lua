function(opts)
  local orig_buf = vim.api.nvim_get_current_buf()
  local orig_lines = vim.api.nvim_buf_get_lines(orig_buf, 0, -1, false)
  local orig_str = table.concat(orig_lines, "\n") .. "\n"

  local orig_path = vim.api.nvim_buf_get_name(orig_buf)
  local filename = vim.fn.fnamemodify(orig_path, ":t")
  local extension = vim.fn.fnamemodify(orig_path, ":e")
  local basename = vim.fn.fnamemodify(filename, ":r")
  basename = basename:match("([^?#]+)")

  local function resolve_dir(path)
    local repo, rel_path = path:match("^diffview://(.-)/%.git/[^/]+/(.*)$")
    if repo and rel_path then
      return vim.fn.fnamemodify(repo .. "/" .. rel_path, ":h")
    end

    local clean_path = path:gsub("^%a+://", "")
    return vim.fn.fnamemodify(clean_path, ":h")
  end

  local dir = resolve_dir(orig_path)
  local tmp_filename = string.format("%s_gitlab_suggestion.%s", basename, extension)
  local tmpname = dir .. "/" .. tmp_filename

  local f = io.open(tmpname, "w")
  if not f then
    vim.notify("Error creating file at " .. tmpname, vim.log.levels.ERROR)
    return
  end
  f:write(orig_str)
  f:close()

  local width = math.floor(vim.o.columns * 0.9)
  local height = math.floor(vim.o.lines * 0.9)

  local win_opts = {
    relative = "editor",
    width = width,
    height = height,
    col = math.floor((vim.o.columns - width) / 2),
    row = math.floor((vim.o.lines - height) / 2),
    style = "minimal",
    border = "rounded",
    title = " Suggestion ",
    title_pos = "center",
  }

  local float_buf = vim.api.nvim_create_buf(false, true)
  local float_win = vim.api.nvim_open_win(float_buf, true, win_opts)

  vim.cmd("edit " .. tmpname)
  local scratch_buf = vim.api.nvim_get_current_buf()
  vim.bo[scratch_buf].bufhidden = "wipe"

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = orig_buf })) do
    vim.lsp.buf_attach_client(scratch_buf, client.id)
  end

  local ns = vim.api.nvim_create_namespace("gitlab_suggest_signs")

  local function update_signs()
    local current_lines = vim.api.nvim_buf_get_lines(scratch_buf, 0, -1, false)
    local current_str = table.concat(current_lines, "\n") .. "\n"
    local hunks = vim.text.diff(orig_str, current_str, { result_type = "indices" })

    vim.api.nvim_buf_clear_namespace(scratch_buf, ns, 0, -1)
    if not hunks then return end

    for _, h in ipairs(hunks) do
      local count_a, start_b, count_b = h[2], h[3], h[4]

      if count_b > 0 then
        local is_add = (count_a == 0)
        local hl_group = is_add and "GitSignsAdd" or "GitSignsChange"

        for i = start_b, start_b + count_b - 1 do
          pcall(vim.api.nvim_buf_set_extmark, scratch_buf, ns, i - 1, 0, {
            sign_text = "▎",
            sign_hl_group = hl_group,
          })
        end
      elseif count_b == 0 and start_b > 0 then
        pcall(vim.api.nvim_buf_set_extmark, scratch_buf, ns, start_b - 1, 0, {
          sign_text = "",
          sign_hl_group = "GitSignsDelete",
        })
      end
    end
  end

  update_signs()
  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    buffer = scratch_buf,
    callback = update_signs,
    desc = "Update diff signs for GitLab suggestion",
  })

  vim.notify("Press <C-s> to copy suggestion block", vim.log.levels.INFO)

  vim.api.nvim_create_autocmd("BufWipeout", {
    buffer = scratch_buf,
    callback = function()
      os.remove(tmpname)
    end,
    desc = "Clean up GitLab review temp file",
  })

  vim.keymap.set("n", "<C-s>", function()
    vim.cmd("silent! write")

    local new_lines = vim.api.nvim_buf_get_lines(scratch_buf, 0, -1, false)
    local new_str = table.concat(new_lines, "\n") .. "\n"

    local hunks = vim.text.diff(orig_str, new_str, { result_type = "indices" })
    if not hunks or #hunks == 0 then
      vim.notify("No changes found", vim.log.levels.WARN)
      vim.api.nvim_win_close(float_win, true)
      os.remove(tmpname)
      return
    end

    local h_last = hunks[#hunks]
    local last_start_a, last_count_a = h_last[1], h_last[2]
    if last_count_a == 0 then
      last_start_a = math.max(1, last_start_a)
    end
    local target_line = last_start_a + math.max(0, last_count_a - 1)

    local result = {}

    for _, h in ipairs(hunks) do
      local start_a, count_a, start_b, count_b = h[1], h[2], h[3], h[4]

      if count_a == 0 then
        start_a = math.max(1, start_a)
      end

      local end_a = start_a + math.max(0, count_a - 1)

      local offset_start = start_a - target_line
      local offset_end = end_a - target_line

      local prefix = (offset_start == 0) and "-0" or tostring(offset_start)
      local suffix = (offset_end == 0) and "+0" or tostring(offset_end)

      table.insert(result, string.format("```suggestion:%s%s", prefix, suffix))

      for i = start_b, start_b + count_b - 1 do
        table.insert(result, new_lines[i])
      end

      table.insert(result, "```")
      table.insert(result, "")
    end

    if #result > 0 and result[#result] == "" then
      table.remove(result)
    end

    local text = table.concat(result, "\n")
    vim.fn.setreg("+", text)

    vim.notify("Copied blocks! Place your comment on line: " .. target_line, vim.log.levels.INFO)

    vim.api.nvim_win_close(float_win, true)
  end, { buffer = scratch_buf, desc = "Generate suggestion blocks" })
end
