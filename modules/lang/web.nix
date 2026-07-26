{lib, ...}: let
  prettier_config = import ./.prettier.nix;
in {
  name = "lang-web";

  moduleOptions = with lib; {
    lang.web.enable = mkEnableOption "Enable Web development language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.web.enable {
      home.packages = with pkgs; [
        prettier
        prettierd
        stylelint
        eslint_d
        typescript-language-server
        tailwindcss-language-server
        astro-language-server
        vscode-langservers-extracted
      ];

      lang.meta.web = {
        enable = true;
        lsps = ["html" "ts_ls" "cssls" "eslint" "tailwindcss" "astro"];
        linters = {
          css = ["stylelint"];
          javascript = ["eslint_d"];
          javascriptreact = ["eslint_d"];
          typescript = ["eslint_d"];
          typescriptreact = ["eslint_d"];
        };
        formatters = {
          html = prettier_config;
          css = prettier_config;
          javascript = prettier_config;
          typescript = prettier_config;
          javascriptreact = prettier_config;
          typescriptreact = prettier_config;
          astro = prettier_config;
        };
      };
    };
}
