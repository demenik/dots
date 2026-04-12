{
  name = "opencode";

  modules = [./default.nix];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    mcp = import ./.mcp-servers.nix {inherit lib config;};
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

        mcp = lib.mapAttrs (name: server:
          {
            type = "remote";
            inherit (server) url;
          }
          // lib.optionalAttrs (server ? authHeader) {
            headers.${server.authHeader} = "{env:${server.envVar}}";
          })
        mcp.servers;
      };
    };
  };
}
