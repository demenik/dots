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

          local prog = line:match("^#!.*bin/env%s+([^%s]+)")
          if not prog then
            prog = line:match("^#!.*/([^%s]+)")
          end

          if prog then
            local ft = prog:gsub("%d+$", "")
            vim.bo.filetype = ft
          end
        end
      '';
    }
  ];
}
