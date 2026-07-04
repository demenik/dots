{
  name = "gemini-cli";

  modules = [./default.nix];

  overlays.home = [
    (final: prev: {
      gemini-cli-catppuccin-theme = final.fetchurl {
        url = "https://raw.githubusercontent.com/catppuccin/gemini-cli/refs/heads/main/themes/catppuccin-mocha.json";
        hash = "sha256-dRD5ixkbdRgnejWkLSzSnBWzlQap4Kz18n49NtXQfU4=";
      };
    })
  ];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    setTitle =
      pkgs.writeText "set-gemini-title.js"
      # js
      ''
        process.title = "gemini";
      '';

    utils = import ./.utils.nix {inherit pkgs lib config;};

    gemini-cli-wrapped = pkgs.symlinkJoin {
      name = "gemini-cli-wrapped";
      paths = [pkgs.gemini-cli];
      buildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out"/bin/gemini \
          --run 'export NODE_OPTIONS="--require ${setTitle} $${NODE_OPTIONS:-}"' \
          ${builtins.concatStringsSep " " utils.wrapperArgs}
      '';
    };
  in {
    home.packages = [gemini-cli-wrapped];

    home.file = lib.mkMerge [
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
            customThemes."Catppuccin Mocha" = builtins.fromJSON (builtins.readFile pkgs.gemini-cli-catppuccin-theme);

            footer.hideSandboxStatus = true;
            useAlternateBuffer = true;
            inlineThinkingMode = "full";
          };

          output.format = "text";

          privacy.usageStatisticsEnabled = false;
          telemetry.enabled = false;
          tools.shell.showColor = true;

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
        };
      }

      (utils.mkSkillDirLinks ".gemini/skills")
    ];
  };
}
