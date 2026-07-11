{
  name = "antigravity-cli";

  modules = [./default.nix];

  overlays.home = [
    (final: prev: {
      antigravity-cli = prev.antigravity-cli.overrideAttrs (old: rec {
        passthru =
          (old.passthru or {})
          // {
            fmUpdate = {
              version = "1.1.1-6269367663591424";
              script = "curl -sL https://antigravity.google/cli/install.sh | grep -oP 'DOWNLOAD_BASE_URL=\"\\K[^\"]+' | xargs -I {} curl -sL {}/manifests/linux_amd64.json | grep -oP '\"url\": \".*/antigravity-cli/\\K[^/]+'";
            };
          };

        version = builtins.head (prev.lib.splitString "-" passthru.fmUpdate.version);

        src = prev.fetchurl {
          url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${passthru.fmUpdate.version}/linux-x64/cli_linux_x64.tar.gz";
          hash = "sha256-I/+VgIR4SVtrNV9w2EQXSJpz5d6lVFqvpOH6D9UovJM=";
        };

        meta =
          (old.meta or {})
          // {
            license = prev.lib.licenses.free;
          };
      });
    })
  ];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    utils = import ./.utils.nix {inherit pkgs lib config;};

    antigravity-cli-wrapped = pkgs.symlinkJoin {
      name = "antigravity-cli-wrapped";
      paths = [pkgs.antigravity-cli];
      nativeBuildInputs = [pkgs.makeWrapper];
      postBuild = ''
        wrapProgram "$out/bin/agy" \
          --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.nodejs]} \
          ${builtins.concatStringsSep " " utils.wrapperArgs}
      '';
    };
  in {
    home.packages = [antigravity-cli-wrapped];

    home.file = lib.mkMerge [
      {
        ".gemini/config/mcp_config.json".text = builtins.toJSON {
          mcpServers =
            lib.mapAttrs (
              name: server:
                lib.filterAttrs (n: v: v != null && v != {}) {
                  command =
                    if server.type == "remote"
                    then "npx"
                    else utils.getCommand server;
                  args =
                    if server.type == "remote"
                    then [
                      "-y"
                      "mcp-remote@0.1.38"
                      server.url
                      "--transport"
                      (
                        if lib.hasPrefix "http://" server.url
                        then "http-only"
                        else "sse"
                      )
                    ]
                    else utils.getArgs server;
                  env = lib.filterAttrs (k: v: v != null) (
                    lib.mapAttrs (
                      k: v:
                        if v.text != null
                        then v.text
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
