{
  programs.nixvim.autoCmd = [
    {
      event = ["BufReadPost" "BufNewFile" "TextChanged" "TextChangedI"];
      pattern = "*";
      callback.__raw = ''
        function()
          local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
          if not line then return end
          if not line:match("^#!") then return end

          local prog = line:match("^#!.*bin/env%s+([^%s]+)")
          if not prog then
            prog = line:match("^#!.*/([^%s]+)")
          end

          if prog then
            local ft = prog:gsub("%d+$", "")
            if vim.bo.filetype ~= ft then
              vim.bo.filetype = ft
            end
          end
        end
      '';
    }
  ];
}
