{
  imports = [./conform.nix];

  plugins.mini = {
    modules = {
      align = {};
      indentscope = {
        symbol = "▏";
        draw.delay = 0;
        options.try_as_border = true;
      };
    };
  };

  extraConfigLua =
    # lua
    ''
      vim.api.nvim_create_autocmd("FileType", {
        desc = "Disable indentscope for certain filetypes",
        pattern = {
          "help",
          "NvimTree",
          "toggleterm",
          "Trouble",
          "snacks_dashboard",
          "leetcode.nvim",
        },
        callback = function()
          vim.b.miniindentscope_disable = true
        end,
      })
    '';
}
