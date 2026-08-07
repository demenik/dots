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
  in {
    home.file.".claude/CLAUDE.md".source = ./.guidelines.md;

    programs.claude-code = {
      enable = true;
      package = claude-code-wrapped;

      settings = {
        editorMode = "vim";

        defaultMode = "acceptEdits";
        permissions = utils.claudeCodePermissions;

        hooks = {
          Notification = let
            mkNotify = matchers: content:
              map (matcher: {
                inherit matcher;
                hooks = [
                  {
                    type = "command";
                    command = "${lib.getExe' pkgs.libnotify "notify-send"} 'Claude Code' '${content}'";
                  }
                ];
              })
              matchers;
          in
            lib.mkMerge [
              (mkNotify ["permission_prompt" "elicitation_dialog" "agent_needs_input"] "Claude Code requires user input")
              (mkNotify ["idle_prompt" "agent_completed"] "Claude Code is done")
            ];
        };

        attribution = {
          commit = "";
          pr = "";
          sessionUrl = false;
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
