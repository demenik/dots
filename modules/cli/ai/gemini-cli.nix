{
  name = "gemini-cli";

  modules = [./default.nix];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    mcp = import ./.mcp-servers.nix {inherit lib config;};
    skills = import ./.skills {inherit pkgs lib;};

    setTitle =
      pkgs.writeText "set-gemini-title.js"
      # js
      ''
        process.title = "gemini";
      '';

    gemini-cli-wrapped = pkgs.symlinkJoin {
      name = "gemini-cli-wrapped";
      paths = [pkgs.gemini-cli];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out"/bin/gemini \
          --run 'export NODE_OPTIONS="--require ${setTitle} $${NODE_OPTIONS:-}"' \
          ${builtins.concatStringsSep " " mcp.wrapperArgs}
      '';
    };
  in {
    home.packages = [gemini-cli-wrapped];

    home.file =
      {
        ".gemini/settings.json".text = builtins.toJSON {
          general = {
            vimMode = false;
            preferredEditor = "neovim";
            disableAutoUpdate = true;
            disableUpdateNag = true;
            previewFeatures = true;
          };

          security.auth.selectedType = "oauth-personal";

          ui = {
            theme = "Catppuccin Mocha";
            customThemes."Catppuccin Mocha" = builtins.fromJSON (builtins.readFile (pkgs.fetchurl {
              url = "https://raw.githubusercontent.com/catppuccin/gemini-cli/refs/heads/main/themes/catppuccin-mocha.json";
              hash = "sha256-dRD5ixkbdRgnejWkLSzSnBWzlQap4Kz18n49NtXQfU4=";
            }));

            footer.hideSandboxStatus = true;
            useAlternateBuffer = true;
          };

          output.format = "text";

          privacy.usageStatisticsEnabled = false;
          telemetry.enabled = false;
          tools.shell.showColor = true;

          mcpServers = lib.mapAttrs (name: server:
            {
              inherit (server) url;
            }
            // lib.optionalAttrs (server ? authHeader) {
              env.${server.authHeader} = "\$${server.envVar}";
              headers.${server.authHeader} = "\$${server.envVar}";
            })
          mcp.servers;
        };
      }
      // skills.mkSkillDirLinks ".gemini/skills";
  };
}
