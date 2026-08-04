{lib, ...}: {
  name = "lang-java";

  moduleOptions = with lib; {
    lang.java.enable = mkEnableOption "Enable Java language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.java.enable {
      home.packages = with pkgs; [
        checkstyle
        jdt-language-server
      ];

      lang.meta.java = {
        enable = true;
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
