{
  pkgs,
  config,
  ...
}: {
  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      scrollEOF
      vim_current_word
    ];

    plugins = {
      noice.enable = true;

      colorizer = {
        enable = true;
        settings = {
          user_default_options = {
            RRGGBBAA = true;
          };
          filetypes = {
            "*" = {};

            nix.names_custom =
              pkgs.lib.filterAttrs
              (n: v: builtins.isString v && builtins.match "base[0-9A-F]{2}" n != null)
              config.colors.withHashtag;

            css.css = true;
            scss = {
              css = true;
              sass.enable = true;
            };
            sass = {
              css = true;
              sass.enable = true;
            };

            html.tailwind = "both";
            javascript.tailwind = "both";
            typescript.tailwind = "both";
            javascriptreact.tailwind = "both";
            typescriptreact.tailwind = "both";
          };
        };
      };
    };

    extraConfigLua = ''
      vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
          local cp = require("catppuccin.palettes").get_palette()
          vim.api.nvim_set_hl(0, "CurrentWord", { fg = cp.mauve })
        end,
      })
      pcall(function()
        local cp = require("catppuccin.palettes").get_palette()
        vim.api.nvim_set_hl(0, "CurrentWord", { fg = cp.mauve })
      end)

      vim.cmd([[
        let g:vim_current_word#hightlight_twins = 0
        let g:vim_current_word#excluded_filetypes = ["minifiles", "netrw", "snacks_dashboard"]
      ]])
    '';
  };
}
