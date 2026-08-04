{lib, ...}: {
  name = "lang-java";

  moduleOptions = with lib; {
    lang.java = {
      enable = mkEnableOption "Enable Java language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Java lsp/linter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.java;
    packages = {
      inherit (pkgs) checkstyle;
      jdtls = pkgs.jdt-language-server;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.java = {
        enable = true;
        inherit packages;
        lsps = ["jdtls"];
        linters = {
          java = ["checkstyle"];
        };
        formatters = {};
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "jdtls-lsp" = "${pkgs.claude-plugins}/plugins/jdtls-lsp";
      };
    };
}
