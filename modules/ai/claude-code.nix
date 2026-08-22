{
  name = "claude-code";

  modules = [./default.nix];

  overlays.both = [
    (final: prev: {
      claude-plugins = final.fetchFromGitHub {
        owner = "anthropics";
        repo = "claude-plugins-official";
        rev = "b7e93a4e7c950ba5b22a2bdb9a61e2631f75a51e";
        hash = "sha256-u6suHaAGCr3BufCUYhcgmwx/UWovCY7RPUCfKCg/0SU=";
      };
    })
  ];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    utils = import ./.utils.nix {inherit pkgs lib config;};

    claude-code-wrapped = pkgs.symlinkJoin {
      name = "claude-code-wrapped";
      version = pkgs.claude-code.version;
      paths = [pkgs.claude-code];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out"/bin/claude \
          ${builtins.concatStringsSep " " utils.wrapperArgs}
      '';
    };

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
  in {
    home.file.".claude/CLAUDE.md".source = ./.guidelines.md;

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

    programs.claude-code = {
      enable = true;
      package = claude-code-wrapped;

      settings = {
        editorMode = "vim";

        permissions =
          {
            defaultMode = "acceptEdits";
            disableAutoMode = "disable";
          }
          // utils.claudeCodePermissions;

        attribution = {
          commit = "";
          pr = "";
          sessionUrl = false;
        };

        hooks = {
          UserPromptSubmit = [(statusHook "UserPromptSubmit")];
          PostToolUse = [({matcher = "";} // statusHook "PostToolUse")];
          Notification = [(statusHook "Notification")];
          Stop = [(statusHook "Stop")];
          SessionStart = [(statusHook "SessionStart")];
          SessionEnd = [(statusHook "SessionEnd")];
        };
      };

      mcpServers =
        lib.mapAttrs (
          name: server:
            lib.filterAttrs (n: v: v != null && v != {}) {
              command = utils.getCommand server;
              args = utils.getArgs server;
              inherit (server) url headers;

              env = lib.filterAttrs (k: v: v != null) (
                lib.mapAttrs (
                  k: v:
                    if v.text != null
                    then v.text
                    else if v.path != null
                    then "\$${k}"
                    else null
                )
                server.env
              );
            }
        )
        config.ai.mcp;
      skills = lib.mapAttrs utils.mkSkillDrv config.ai.skills;
    };
  };
}
