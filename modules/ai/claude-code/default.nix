{
  name = "claude-code";

  modules = [../default.nix];

  overlays.both = [
    (final: prev: {
      claude-plugins = final.fetchFromGitHub {
        owner = "anthropics";
        repo = "claude-plugins-official";
        rev = "ea10b213686c90bb1984b2016937310e05336cf3";
        hash = "sha256-Tfs8Ig1rzLvaAuTZwqGUzKCK0TMWE2SddYss+H/04ug=";
      };
    })
  ];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    utils = import ../.utils.nix {inherit pkgs lib config;};

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
    imports = [./tmux-status.nix];

    home.file.".claude/CLAUDE.md".text = config.ai.guidelines.text;

    home.file."${config.programs.claude-code.configDir}/settings.json".force = true;

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
      };

      mcpServers =
        lib.mapAttrs (
          name: server: utils.mkMcpServer {inherit name server;}
        )
        config.ai.mcp;
      skills = lib.mapAttrs utils.mkSkillDrv config.ai.skills;
    };
  };
}
