{
  name = "claude-code";

  modules = [./default.nix];

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
    programs.claude-code = {
      enable = true;
      package = claude-code-wrapped;

      settings = {
        defaultMode = "acceptEdits";
        permissions = {
          allow = [
            "Read(./.env.example)"

            "Bash(nix eval *)"

            "Bash(git log *)"
            "Bash(git diff *)"
            "Bash(git status *)"

            "Bash(cargo build *)"
            "Bash(cargo check *)"
            "Bash(cargo test *)"
            "Bash(cargo fmt *)"

            "Bash(bun install *)"
          ];
          ask = [
            "Read(./.env)"
            "Read(./.env.*)"
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
