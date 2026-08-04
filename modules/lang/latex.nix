{lib, ...}: {
  name = "lang-latex";

  moduleOptions = with lib; {
    lang.latex = {
      enable = mkEnableOption "Enable LaTeX language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add the LaTeX lsp to PATH (the sioyek viewer and tectonic compiler are always added)";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.latex;
    packages = {
      inherit (pkgs) texlab;
    };
  in
    lib.mkIf cfg.enable {
      home.packages =
        [pkgs.sioyek pkgs.tectonic]
        ++ lib.optionals cfg.onPath (builtins.attrValues packages);

      lang.meta.latex = {
        enable = true;
        inherit packages;
        lsps = ["texlab"];
        linters = {};
        formatters = {};
      };
    };
}
