{
  pkgs,
  lib,
  ...
}: let
  jlog = pkgs.writeShellApplication {
    name = "jlog";
    runtimeInputs = with pkgs; [systemd gawk fzf];
    text = builtins.readFile ./jlog.sh;
  };
in {
  home.packages = [jlog];

  xdg.configFile."zsh/completions/_jlog".text =
    # zsh
    ''
      #compdef jlog

      _jlog() {
        local -a units

        units=( $(systemctl list-units --all --no-legend --full --no-pager --type=service | awk '{print ($1 == "●" || $1 == "*") ? $2 : $1}') )

        if systemctl --user is-system-running &>/dev/null; then
          units+=( $(systemctl --user list-units --all --no-legend --full --no-pager --type=service 2>/dev/null | awk '{print ($1 == "●" || $1 == "*") ? $2 : $1}') )
        fi

        compadd -J services -X 'service' -a units
      }

      _jlog "$@"
    '';

  programs.zsh.initContent = lib.mkBefore ''
    fpath=(~/.config/zsh/completions $fpath)
  '';
}
