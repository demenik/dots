{lib, ...}: {
  name = "lang-nix";

  moduleOptions = with lib; {
    lang.nix.enable = mkEnableOption "Enable Nix language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.nix.enable {
      home.packages = with pkgs; [
        statix
        alejandra
        nixfmt
        nixd
      ];

      lang.meta.nix = {
        enable = true;
        lsps = ["nixd"];
        linters = {
          nix = ["statix"];
        };
        formatters = {
          nix = ["alejandra" "injected"];
        };
      };
    };
}
