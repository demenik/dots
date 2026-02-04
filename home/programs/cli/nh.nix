{
  pkgs,
  lib,
  dotsDir,
  ...
}: let
  nh-wrapped = pkgs.writeShellApplication {
    name = "nh";
    runtimeInputs = with pkgs; [git nh];
    text = ''
      export NH_FLAKE="${dotsDir}"

      if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
        git add --intent-to-add .
      fi

      exec ${lib.getExe pkgs.nh} "$@"
    '';
  };
in {
  programs.nh = {
    enable = true;
    package = nh-wrapped;

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 1d";
    };
  };
}
