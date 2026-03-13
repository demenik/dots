{
  pkgs,
  lib,
  config,
  ...
}: let
  context7_api_key = config.age.secrets.mcp-context7.path;
  opencode-wrapped = pkgs.symlinkJoin {
    name = "opencode-wrapped";
    paths = [pkgs.opencode];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out"/bin/opencode \
        --run 'export CONTEXT7_API_KEY=$(cat "${context7_api_key}")'
    '';
  };
in {
  home.packages = with pkgs; [
    gemini-cli
  ];

  home.file = {
    ".gemini/settings.json".text = builtins.toJSON {
      general = {
        vimMode = false;
        preferredEditor = "neovim";
        disableAutoUpdate = true;
        disableUpdateNag = true;
        previewFeatures = true;
        enablePromptCompletion = true;
      };
      security.auth.selectedType = "oauth-personal";
      ui = {
        # theme = "Catppuccin Mocha";
        # customThemes."Catppuccin Mocha" = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
        #   url = "https://raw.githubusercontent.com/catppuccin/gemini-cli/refs/heads/main/themes/catppuccin-mocha.json";
        #   hash = "sha256-BL4tR3cxM5nG3Hws5OaYbYQOvB4XLYN6uNFkXWIp1nU=";
        # }));
        footer.hideSandboxStatus = true;
        useAlternateBuffer = true;
      };
      output = {
        format = "text";
      };
      privacy.usageStatisticsEnabled = false;
      telemetry.enabled = false;
      tools.shell.showColor = true;
    };
  };

  programs.opencode = {
    enable = true;
    package = opencode-wrapped;

    settings = {
      theme = lib.mkForce "catppuccin";
      plugin = ["opencode-gemini-auth@latest"];

      permission = {
        "*" = "ask";
        read = {
          "*" = "allow";
          "*.env" = "deny";
          "*.env.*" = "deny";
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
        context7_resolve-library-id = "allow";
        context7_query-docs = "allow";
        gitmcp_match_common_libs_owner_repo_mapping = "allow";
        gitmcp_fetch_generic_documentation = "allow";
        gitmcp_search_generic_documentation = "allow";
        gitmcp_search_generic_code = "allow";
        gitmcp_fetch_generic_url_content = "allow";

        bash = {
          "*" = "ask";
          "find *" = "allow";
          "ls *" = "allow";
          "nix eval *" = "allow";
          "cat *" = "allow";

          "git log *" = "allow";
          "git diff *" = "allow";
          "git status *" = "allow";
        };
      };

      mcp = {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          headers.CONTEXT7_API_KEY = "{env:CONTEXT7_API_KEY}";
        };
        gitmcp = {
          type = "remote";
          url = "https://gitmcp.io/docs";
        };
      };
    };
  };
}
