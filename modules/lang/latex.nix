{lib, ...}: {
  name = "lang-latex";

  moduleOptions = with lib; {
    lang.latex.enable = mkEnableOption "Enable LaTeX language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.latex.enable {
      home.packages = with pkgs; [
        sioyek
        tectonic
        texlab
      ];

      lang.meta.latex = {
        enable = true;
        lsps = ["texlab"];
        linters = {};
        formatters = {};
      };
    };
}
