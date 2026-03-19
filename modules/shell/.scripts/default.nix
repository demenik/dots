{
  pkgs,
  lib,
  ...
}: {
  home.packages = with pkgs; [
    (writeShellApplication {
      name = "nix";
      text =
        # bash
        ''
          NIX=${lib.getExe pkgs.nix}

          if [[ "$1" == "develop" || "$1" == "shell" ]]; then
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
      runtimeInputs = with pkgs; [git];
      text = builtins.readFile ./git-changes.sh;
    })
    (writeShellApplication {
      name = "copy";
      runtimeInputs = with pkgs; [wl-clipboard];
      text = builtins.readFile ./copy.sh;
    })
    (writeShellApplication {
      name = "boot-next";
      runtimeInputs = with pkgs; [efibootmgr];
      text = builtins.readFile ./boot-next.sh;
    })
  ];
}
