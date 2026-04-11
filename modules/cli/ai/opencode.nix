{
  name = "opencode";

  modules = [./default.nix];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    context7_api_key =
      if config.sops.secrets ? mcp-context7
      then config.sops.secrets.mcp-context7.path
      else null;

    mcpKeys = lib.filterAttrs (k: v: v != null) {
      CONTEXT7_API_KEY = context7_api_key;
    };
    mcpLines =
      lib.mapAttrsToList
      (name: path: "--run 'export ${name}=$(cat \"${path}\")'")
      mcpKeys;

    opencode-wrapped = pkgs.symlinkJoin {
      name = "opencode-wrapped";
      paths = [pkgs.opencode];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out"/bin/opencode ${builtins.concatStringsSep " " mcpLines}
      '';
    };
  in {
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

        mcp = lib.filterAttrs (k: v: v != null) {
          context7 =
            if context7_api_key != null
            then {
              type = "remote";
              url = "https://mcp.context7.com/mcp";
              headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
            }
            else null;

          gitmcp = {
            type = "remote";
            url = "https://gitmcp.io/docs";
          };
        };
      };
    };
  };
}
