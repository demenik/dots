{lib, ...}: {
  name = "lang-kotlin";

  moduleOptions = with lib; {
    lang.kotlin.enable = mkEnableOption "Enable Kotlin language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.kotlin.enable {
      home.packages = with pkgs; [
        kotlin-language-server
        ktlint
      ];

      lang.meta.kotlin = {
        enable = true;
        lsps = ["kotlin_lsp"];
        linters = {
          kotlin = ["ktlint"];
        };
        formatters = {
          kotlin = ["ktlint"];
        };
      };
    };
}
