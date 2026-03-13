{
  programs.nixvim.autoCmd = [
    {
      event = ["BufReadPost" "BufNewFile"];
      pattern = "*";
      callback.__raw = ''
        function()
          if vim.bo.filetype ~= "" then return end

          local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
          if not line then return end

          if line:match("^#!.*bin/env%s+python") or line:match("^#!.*bin/python") then
            vim.bo.filetype = "python"
          elseif line:match("^#!.*bin/sh") then
            vim.bo.filetype = "sh"
          elseif line:match("^#!.*bin/bash") or line:match("^#!.*bin/env%s+bash") then
            vim.bo.filetype = "bash"
          end
        end
      '';
    }
  ];
}
