{lib, ...}: {
  name = "lang-markdown";

  moduleOptions = with lib; {
    lang.markdown = {
      enable = mkEnableOption "Enable Markdown language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Markdown lsp/linter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.markdown;
    packages = {
      inherit (pkgs) marksman markdownlint-cli2;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.markdown = {
        enable = true;
        inherit packages;
        lsps = ["marksman"];
        linters = {
          markdown = ["markdownlint-cli2"];
        };
        formatters = {};
      };
    };
}
