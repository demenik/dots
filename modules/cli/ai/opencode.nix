{
  name = "opencode";

  modules = [./default.nix];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    mcp = import ./.mcp-servers.nix {inherit pkgs lib config;};
    skills = import ./.skills {inherit pkgs lib;};

    opencode-wrapped = pkgs.symlinkJoin {
      name = "opencode-wrapped";
      paths = [pkgs.opencode];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out"/bin/opencode ${builtins.concatStringsSep " " mcp.wrapperArgs}
      '';
    };
  in {
    home.file = skills.mkSkillDirLinks ".config/opencode/skills";

    programs.opencode = {
      enable = true;
      package = opencode-wrapped;

      settings = {
        theme = "catppuccin";
        plugin = [
          "opencode-gemini-auth@latest"
        ];

        permission = {
          "*" = "ask";

          read = {
            "*" = "allow";
            "*.env" = "ask";
            "*.env.*" = "ask";
            "*.env.example" = "allow";
          };
          list = "allow";
          glob = "allow";
          grep = "allow";

          todoread = "allow";
          todowrite = "allow";

          webfetch = "allow";
          websearch = "allow";
          codesearch = "allow";

          bash = {
            "*" = "ask";
            "ls *" = "allow";
            "nix eval *" = "allow";

            "git log *" = "allow";
            "git diff *" = "allow";
            "git status *" = "allow";
          };

          context7_resolve-library-id = "allow";
          context7_query-docs = "allow";

          gitmcp_match_common_libs_owner_repo_mapping = "allow";
          gitmcp_fetch_generic_documentation = "allow";
          gitmcp_search_generic_documentation = "allow";
          gitmcp_search_generic_code = "allow";
          gitmcp_fetch_generic_url_content = "allow";
        };

        mcp =
          lib.mapAttrs (
            name: server: let
              isRemote = server ? url;

              remoteConfig = {
                type = "remote";
                inherit (server) url;
                headers =
                  if server ? authHeader
                  then {
                    ${server.authHeader} = "{env:${server.envVar}}";
                  }
                  else null;
              };

              localConfig = {
                type = "local";
                command = [server.command] ++ (server.args or []);
                environment = server.env or null;
              };
            in
              lib.filterAttrs (n: v: v != null && v != {}) (
                if isRemote
                then remoteConfig
                else localConfig
              )
          )
          mcp.servers;
      };
    };
  };
}
