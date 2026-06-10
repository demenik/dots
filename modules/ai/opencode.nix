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

      settings = {
        theme = "system";
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
          edit."*" = "allow";
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
              remoteConfig = {
                type = "remote";
                inherit (server) url;
                headers =
                  lib.mapAttrs (
                    k: v:
                      builtins.replaceStrings
                      (map (s: "\$${s}") (lib.attrNames server.env))
                      (map (s: "{env:${s}}") (lib.attrNames server.env))
                      v
                  )
                  server.headers;
              };

              localConfig = let
                envFiltered = lib.filterAttrs (k: v: v != null) (
                  lib.mapAttrs (
                    k: v:
                      if v.text != null
                      then v.text
                      else null
                  )
                  server.env
                );
              in {
                type = "local";
                inherit (server) command;
                environment =
                  if envFiltered == {}
                  then null
                  else envFiltered;
              };
            in
              lib.filterAttrs (n: v: v != null && v != {}) (
                if server.type == "remote"
                then remoteConfig
                else localConfig
              )
          )
          config.ai.mcp;
      };
    };
  };
}
