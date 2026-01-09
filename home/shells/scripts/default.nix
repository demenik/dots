{
  pkgs,
  dotsDir,
  ...
}: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "rebuild";
      text =
        # bash
        ''
          cd "${dotsDir}" || exit
          git add --intent-to-add . 2>/dev/null
          nixos-rebuild "$@" switch --flake . --sudo
          cd - >/dev/null || exit
        '';
    })
    (writeShellApplication {
      name = "update";
      text =
        # bash
        ''
          cd "${dotsDir}" || exit
          git add --intent-to-add . 2>/dev/null
          nix flake "$@" update
          cd - >/dev/null || exit
        '';
    })
    (writeShellApplication {
      name = "nix";
      text =
        # bash
        ''
          NIX=${pkgs.lib.getExe pkgs.nix}

          if [[ $1 == "develop" || $1 == "shell" ]]; then
            cmd=$1
            shift
            exec "$NIX" "$cmd" -c "$SHELL" "$@"
          else
            exec "$NIX" "$@"
          fi
        '';
    })
    (writeShellApplication {
      name = "git-changes";
      text = builtins.readFile ./git-changes.sh;
    })
    (writeShellApplication {
      name = "copy";
      text = builtins.readFile ./copy.sh;
    })
    (writeShellApplication {
      name = "boot-next";
      runtimeInputs = [
        efibootmgr
      ];
      text = builtins.readFile ./boot-next.sh;
    })
  ];
}
