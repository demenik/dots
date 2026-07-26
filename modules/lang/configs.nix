{lib, ...}: let
  prettier_config = import ./.prettier.nix;
in {
  name = "lang-configs";

  moduleOptions = with lib; {
    lang.configs.enable = mkEnableOption "Enable configuration files language tools (JSON, YAML, TOML, XML)";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.configs.enable {
      home.packages = with pkgs; [
        yamlfmt
        yamllint
        taplo
        yaml-language-server
        lemminx
        vscode-langservers-extracted
      ];

      lang.meta.configs = {
        enable = true;
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
