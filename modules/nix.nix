{
  name = "nix";

  nixos = {pkgs, ...}: {
    nix = {
      package = pkgs.nix;
      settings = {
        auto-optimise-store = true;
        trusted-users = ["root" "@wheel"];
        experimental-features = "nix-command flakes";
        warn-dirty = false;
        download-buffer-size = 512 * 1024 * 1024; # 512 MiB
      };
    };
  };

  home = {
    pkgs,
    inputs,
    lib,
    ...
  }: let
    nh-wrapped = pkgs.writeShellApplication {
      name = "nh";
      runtimeInputs = with pkgs; [git nh];
      text = ''
        export NH_FLAKE="${inputs.self}"

        if git -C "$NH_FLAKE" rev-parse -is-inside-work-tree >/dev/null 2>&1; then
          git -C "$NH_FLAKE" add --intent-to-add .
        fi

        exec "${lib.getExe pkgs.nh}" "$@"
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
  };
}
