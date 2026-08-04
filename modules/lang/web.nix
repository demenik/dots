{lib, ...}: let
  prettier_config = import ./.prettier.nix;
in {
  name = "lang-web";

  moduleOptions = with lib; {
    lang.web = {
      enable = mkEnableOption "Enable Web development language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Web development lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.web;
    packages = {
      inherit (pkgs) stylelint eslint_d prettierd prettier;
      html = pkgs.vscode-langservers-extracted;
      ts_ls = pkgs.typescript-language-server;
      cssls = pkgs.vscode-langservers-extracted;
      eslint = pkgs.vscode-langservers-extracted;
      tailwindcss = pkgs.tailwindcss-language-server;
      astro = pkgs.astro-language-server;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.web = {
        enable = true;
        inherit packages;
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

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "typescript-lsp" = "${pkgs.claude-plugins}/plugins/typescript-lsp";
      };
    };
}
