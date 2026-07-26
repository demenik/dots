{lib, ...}: {
  name = "lang-ruby";

  moduleOptions = with lib; {
    lang.ruby.enable = mkEnableOption "Enable Ruby language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.ruby.enable {
      home.packages = with pkgs; [
        rubocop
        solargraph
      ];

      lang.meta.ruby = {
        enable = true;
        lsps = ["solargraph"];
        linters = {
          ruby = ["rubocop"];
        };
        formatters = {};
      };
    };
}
