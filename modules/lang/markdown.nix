{lib, ...}: {
  name = "lang-markdown";

  moduleOptions = with lib; {
    lang.markdown.enable = mkEnableOption "Enable Markdown language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.markdown.enable {
      home.packages = with pkgs; [
        markdownlint-cli2
        marksman
      ];

      lang.meta.markdown = {
        enable = true;
        lsps = ["marksman"];
        linters = {
          markdown = ["markdownlint-cli2"];
        };
        formatters = {};
      };
    };
}
