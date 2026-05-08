{pkgs, ...}: let
  prettier = (import ../formatting/prettier.nix).prettier;
in {
  programs.nixvim = {
    extraPackages = with pkgs; [
      prettier
      prettierd
      stylelint
    ];

    extraPlugins = with pkgs.vimPlugins; [
      template-string-nvim
    ];

    plugins = {
      lsp.servers = {
        html.enable = true;
        ts_ls.enable = true;
        cssls.enable = true;
        eslint.enable = true;
        tailwindcss.enable = true;
        astro.enable = true;
      };

      lint.lintersByFt = {
        css = ["stylelint"];
        javascript = ["eslint_d"];
        javascriptreact = ["eslint_d"];
        typescript = ["eslint_d"];
        typescriptreact = ["eslint_d"];
      };

      conform-nvim.settings.formatters_by_ft = {
        html = prettier;
        css = prettier;
        javascript = prettier;
        typescript = prettier;
        javascriptreact = prettier;
        typescriptreact = prettier;
        astro = prettier;
      };
    };

    extraConfigLua =
      # lua
      ''
        require("template-string").setup {
          remove_template_string = true,
          restore_quotes = {
            normal = [["]],
            jsx = [["]],
          },
        }
      '';
  };
}
