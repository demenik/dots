{
  pkgs,
  dotsDir,
  ...
}: {
  home.packages = with pkgs; [
    (
      writeScriptBin "rebuild"
      # bash
      ''
        cd "${dotsDir}" || exit
        git add --intent-to-add . 2>/dev/null
        sudo nixos-rebuild $@ switch --flake .
        cd - >/dev/null || exit
      ''
    )
    (
      writeScriptBin "update"
      # bash
      ''
        cd "${dotsDir}" || exit
        git add --intent-to-add . 2>/dev/null
        nix flake $@ update
        cd - >/dev/null || exit
      ''
    )
    (
      writeScriptBin "nix"
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
      ''
    )
    (writeScriptBin "git-changes" (builtins.readFile ./git-changes.sh))
    (writeScriptBin "copy" (builtins.readFile ./copy.sh))
  ];
}
