{
  pkgs,
  dotsDir,
  ...
}: {
  home.packages = with pkgs; [
    (writeScriptBin "rebuild" ''
      cd ${dotsDir}
      git add -A 2>/dev/null
      sudo nixos-rebuild $@ switch --flake .
      cd - >/dev/null
    '')

    (writeScriptBin "update" ''
      cd ${dotsDir}
      git add -A 2>/dev/null
      sudo nix flake $@ update
      cd - >/dev/null
    '')

    (writeScriptBin "nix" ''
      NIX=${pkgs.lib.getExe pkgs.nix}

      if [[ $1 == "develop" || $1 == "shell" ]]; then
        cmd=$1
        shift
        exec "$NIX" "$cmd" -c "$SHELL" "$@"
      else
        exec "$NIX" "$@"
      fi
    '')
  ];
}
