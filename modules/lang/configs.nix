{lib, ...}: let
  prettier_config = import ./.prettier.nix;
in {
  name = "lang-configs";

  moduleOptions = with lib; {
    lang.configs = {
      enable = mkEnableOption "Enable configuration files language tools (JSON, YAML, TOML, XML)";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add configuration file lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.configs;
    packages = {
      inherit (pkgs) taplo lemminx yamllint yamlfmt;
      jsonls = pkgs.vscode-langservers-extracted;
      yamlls = pkgs.yaml-language-server;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.configs = {
        enable = true;
        inherit packages;
        lsps = ["taplo" "jsonls" "yamlls" "lemminx"];
        linters = {
          yaml = ["yamllint"];
        };
        formatters = {
          json = prettier_config;
          yaml = ["yamlfmt"];
        };
      };
    };
}
