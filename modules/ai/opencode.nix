{
  name = "opencode";

  modules = [./default.nix];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    utils = import ./.utils.nix {inherit pkgs lib config;};

    opencode-wrapped = pkgs.symlinkJoin {
      name = "opencode-wrapped";
      paths = [pkgs.opencode];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out"/bin/opencode \
          ${builtins.concatStringsSep " " utils.wrapperArgs}
      '';
    };
  in {
    home.file = utils.mkSkillDirLinks ".config/opencode/skills";

    programs.opencode = {
      enable = true;
      package = opencode-wrapped;

      tui = {
        theme = "system";
      };

      settings = {
        plugin = [
          "opencode-gemini-auth@latest"
        ];

        permission = {"*" = "ask";} // utils.opencodePermissions;

        mcp =
          lib.mapAttrs (
            name: server: let
              remoteConfig = {
                type = "remote";
                inherit (server) url;
                headers =
                  lib.mapAttrs (
                    _: v:
                      builtins.replaceStrings
                      (map (s: "\$${s}") (lib.attrNames server.env))
                      (map (s: "{env:${s}}") (lib.attrNames server.env))
                      v
                  )
                  server.headers;
              };

              localConfig = {
                type = "local";
                command = utils.mcpLocalCommand name server;
                environment = lib.filterAttrs (_: v: v != null) (
                  lib.mapAttrs (_: v: v.text) server.env
                );
              };
            in
              lib.hm.mcp.transformMcpServer {
                server =
                  if server.type == "remote"
                  then remoteConfig
                  else localConfig;
              }
          )
          config.ai.mcp;
      };
    };
  };
}
