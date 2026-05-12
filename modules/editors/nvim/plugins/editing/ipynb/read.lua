function(opts)
  local buf = opts.buf
  local filepath = opts.file

  if vim.fn.getfsize(filepath) <= 0 then
    vim.bo[buf].filetype = "markdown"
    vim.bo[buf].buftype = "acwrite"
    vim.bo[buf].modified = false

    local kernel = vim.g.molten_kernel or "python3"
    pcall(vim.cmd, "MoltenInit " .. kernel)
    return
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Loading notebook..."})

  local cmd = {"jupytext", "--to", "md", "--output", "-", opts.file}
  local output = {}
  local err_output = {}

  vim.fn.jobstart(cmd, {
    stdout_buffered = true,
    stderr_buffered = true,
    on_stdout = function(_, data)
      if data then
        for _, line in ipairs(data) do
          table.insert(output, line)
        end
      end
    end,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then table.insert(err_output, line) end
        end
      end
    end,
    on_exit = function(_, exit_code)
      vim.schedule(function()
        if not vim.api.nvim_buf_is_valid(buf) then return end

        if exit_code ~= 0 then
          local err_msg = table.concat(err_output, "\n")
          err_msg = err_msg ~= "" and err_msg or "Unknown error"

          vim.notify("Error while reading notebook:\n" .. err_msg, vim.log.levels.ERROR)
          vim.api.nvim_buf_set_lines(buf, 0, -1, false, {"Error while loading the notebook"})
          return
        end

        if output[#output] == "" then table.remove(output, #output) end

        vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
        vim.bo[buf].filetype = "markdown"
        vim.bo[buf].buftype = "acwrite"
        vim.bo[buf].modified = false

        local kernel = vim.g.molten_kernel or "python3"
        pcall(vim.cmd, "MoltenInit " .. kernel)
      end)
    end
  })
end
