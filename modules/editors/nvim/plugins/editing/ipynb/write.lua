function(opts)
  local buf = opts.buf
  local filepath = opts.file

  local tmp_md = vim.fn.tempname() .. ".md"
  local lines = vim.api.nvim_buf_get_lines(buf, 0, -1, false)
  vim.fn.writefile(lines, tmp_md)

  local cmd = {
    "jupytext", "--from", "md", "--to", "ipynb"
  }
  if vim.fn.getfsize(filepath) > 0 then
    table.insert(cmd, "--update")
  end
  table.insert(cmd, "--output")
  table.insert(cmd, filepath)
  table.insert(cmd, tmp_md)

  local err_output = {}

  vim.fn.jobstart(cmd, {
    stderr_buffered = true,
    on_stderr = function(_, data)
      if data then
        for _, line in ipairs(data) do
          if line ~= "" then table.insert(err_output, line) end
        end
      end
    end,
    on_exit = function(_, exit_code, _)
      os.remove(tmp_md)

      vim.schedule(function()
        if exit_code == 0 then
          vim.bo[buf].modified = false
          vim.notify("Notebook saved.", vim.log.levels.INFO)
        else
          local err_msg = table.concat(err_output, "\n")
          err_msg = err_msg ~= "" and err_msg or "Unknown error"
          vim.notify("Error while writing notebook:\n" .. err_msg, vim.log.levels.ERROR)
        end
      end)
    end
  })
end
