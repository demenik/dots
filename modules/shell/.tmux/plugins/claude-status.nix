{
  pkgs,
  lib,
  config,
  ...
}: let
  mkBadge = {
    permission,
    working,
    waiting,
    done,
  }:
    "#{?#{==:#{@claude_status},permission},#[blink]#[fg=${permission}] 󰠗 #[noblink]#[fg=default],"
    + "#{?#{==:#{@claude_status},working},#[fg=${working}] 󰦖 #[fg=default],"
    + "#{?#{==:#{@claude_status},waiting},#[fg=${waiting}] 󱋑 #[fg=default],"
    + "#{?#{==:#{@claude_status},done},#[fg=${done}]  #[fg=default],}}}}";

  staticBadge = let
    c = config.colors.withHashtag;
  in
    mkBadge {
      permission = c.base08;
      working = c.base0A;
      waiting = c.base0D;
      done = c.base0B;
    };

  dynamicBadge = mkBadge {
    permission = "\${THEME[red]}";
    working = "\${THEME[yellow]}";
    waiting = "\${THEME[blue]}";
    done = "\${THEME[green]}";
  };

  mkSpliceScript = {
    badge,
    prelude ? "",
  }:
    pkgs.writeShellScript "claude-status-tmux-splice" ''
      ${prelude}
      badge="${badge}"
      for opt in window-status-format window-status-current-format; do
        current="$(${lib.getExe pkgs.tmux} show-options -gv "$opt")"
        new="$(printf '%s' "$current" | sed "s/#W/#W$badge/")"
        ${lib.getExe pkgs.tmux} set -g "$opt" "$new"
      done
    '';

  staticScript = mkSpliceScript {badge = staticBadge;};

  dynamicScript = mkSpliceScript {
    badge = dynamicBadge;
    prelude = ''
      theme_colors="$HOME/.config/tmux/tokyo-night-colors.sh"
      [ -f "$theme_colors" ] || exit 0
      # shellcheck disable=SC1090
      source "$theme_colors"
    '';
  };
in {
  programs.tmux.extraConfig =
    # tmux
    ''
      run-shell ${
        if config.theme.type == "colorScheme"
        then staticScript
        else dynamicScript
      }
    '';
}
