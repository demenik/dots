{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  claude-tmux-status = pkgs.writeShellApplication {
    name = "claude-tmux-status";
    runtimeInputs = [pkgs.tmux pkgs.jq];
    text = ''
      event="''${1:-}"
      pane="''${TMUX_PANE:-}"
      [ -z "$pane" ] && exit 0

      input="$(cat)"

      status=""
      case "$event" in
      UserPromptSubmit | PostToolUse)
        status="working"
        ;;
      Notification)
        message="$(jq -r '.message // ""' <<<"$input")"
        if [[ "$message" == *permission* ]]; then
          status="permission"
        else
          status="waiting"
        fi
        ;;
      Stop)
        status="done"
        ;;
      SessionStart)
        status="waiting"
        ;;
      SessionEnd)
        status=""
        ;;
      esac

      tmux set-option -t "$pane" -w @claude_status "$status" 2>/dev/null || true
    '';
  };

  statusHook = event: {
    hooks = [
      {
        type = "command";
        command = "${lib.getExe claude-tmux-status} ${event}";
      }
    ];
  };
in
  mkIf (config.programs.tmux ? statusIcons) {
    programs.tmux.statusIcons.groups.claude = {
      variable = "@claude_status";
      states = {
        permission = {
          icon = "󰠗";
          color = "red";
          blink = true;
        };
        working = {
          icon = "󰦖";
          color = "yellow";
        };
        waiting = {
          icon = "󱋑";
          color = "blue";
        };
        done = {
          icon = "";
          color = "green";
        };
      };
    };

    programs.claude-code.settings.hooks = {
      UserPromptSubmit = [(statusHook "UserPromptSubmit")];
      PostToolUse = [({matcher = "";} // statusHook "PostToolUse")];
      Notification = [(statusHook "Notification")];
      Stop = [(statusHook "Stop")];
      SessionStart = [(statusHook "SessionStart")];
      SessionEnd = [(statusHook "SessionEnd")];
    };
  }
