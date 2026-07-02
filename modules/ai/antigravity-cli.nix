{
  name = "antigravity-cli";

  modules = [./default.nix];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    utils = import ./.utils.nix {inherit pkgs lib config;};

    antigravity-cli = pkgs.stdenv.mkDerivation rec {
      pname = "antigravity-cli";
      wholeVersion = "1.0.9-5825833043099648";
      version = "1.0.9";

      src = pkgs.fetchurl {
        url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${wholeVersion}/linux-x64/cli_linux_x64.tar.gz";
        sha256 = "sha256-dzngufp5xOksHSIK8+DET33bupvgCTlXUDZPhvpuuPg=";
      };

      nativeBuildInputs = [pkgs.autoPatchelfHook pkgs.makeWrapper];

      buildInputs = with pkgs; [
        stdenv.cc.cc.lib
      ];

      dontBuild = true;
      dontConfigure = true;

      unpackPhase = ''
        mkdir -p source
        tar -xzf "$src" -C source
      '';
      sourceRoot = "source";

      installPhase = ''
        mkdir -p "$out"/bin
        cp antigravity "$out"/bin/agy
        chmod +x "$out"/bin/agy

        wrapProgram "$out"/bin/agy \
          --prefix PATH : ${pkgs.lib.makeBinPath [pkgs.nodejs]} \
          ${builtins.concatStringsSep " " utils.wrapperArgs}
      '';
    };
  in {
    home.packages = [antigravity-cli];

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
