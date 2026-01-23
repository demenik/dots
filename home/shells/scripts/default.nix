{pkgs, ...}: {
  home.packages = with pkgs; [
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
