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
