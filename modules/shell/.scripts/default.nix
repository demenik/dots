{
  pkgs,
  lib,
  ...
}: let
  inherit (pkgs) writeShellApplication;
in {
  imports = [
    ./jlog.nix
  ];

  home.packages = [
    (writeShellApplication {
      name = "nix";
      text =
        # bash
        ''
          NIX=${lib.getExe pkgs.nix}

          if [[ "''${1:-}" == "develop" && -t 0 && -t 1 && -n "''${SHELL:-}" ]]; then
            for arg in "''${@:2}"; do
              case "$arg" in
                -c | --command | --help | --print-dev-env | --phase | --unpack | --configure | --build | --check | --install | --installcheck)
                  exec "$NIX" "$@"
                  ;;
              esac
            done
            exec "$NIX" "$@" -c "$SHELL"
          fi

          exec "$NIX" "$@"
        '';
    })
    (writeShellApplication {
      name = "nix-shell";
      text =
        # bash
        ''
          NIX_SHELL=${pkgs.nix}/bin/nix-shell

          if [[ -t 0 && -t 1 && -n "''${SHELL:-}" ]]; then
            # Shebang mode: nix-shell is invoked as `nix-shell <script> [args]`
            if [[ -f "''${1:-}" ]] && IFS= read -r -n 2 magic <"$1" && [[ "$magic" == "#!" ]]; then
              exec "$NIX_SHELL" "$@"
            fi

            for arg in "$@"; do
              case "$arg" in
                --run | --command | -i | --help | --version)
                  exec "$NIX_SHELL" "$@"
                  ;;
              esac
            done
            exec "$NIX_SHELL" --run "$SHELL" "$@"
          fi

          exec "$NIX_SHELL" "$@"
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
    (writeShellApplication {
      name = "to-nix";
      runtimeInputs = with pkgs; [yj nix uutils-coreutils-noprefix alejandra];
      text = builtins.readFile ./to-nix.sh;
    })
  ];
}
