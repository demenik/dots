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
      version = "1.0.7";

      src = pkgs.fetchurl {
        url = "https://storage.googleapis.com/antigravity-public/antigravity-cli/${version}/linux-x64/cli_linux_x64.tar.gz";
        sha256 = "sha256-9btGXtuTghLrChhdaMQg/1t48Ixy3lptiN/vr3rxcHQ=";
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
        ".gemini/antigravity-cli/keybindings.json".text = builtins.toJSON {
          "cli.enter" = ["enter"];
          "cli.escape" = ["ctrl+c" "esc"];
          "cli.clear_screen" = ["ctrl+l"];
          "cli.exit" = ["ctrl+x"];
          "cli.suspend" = ["ctrl+z"];

          "confirm.edit_command" = ["e"];
          "confirm.yes" = ["y"];
          "confirm.no" = ["n"];

          "edit.open_editor" = ["ctrl+g"];
          "edit.paste" = ["ctrl+v"];
          "edit.redo" = ["ctrl+shift+z"];
          "edit.undo" = ["ctrl+_" "ctrl+shift+-"];
          "edit.yank" = ["ctrl+y"];

          "navigation.up" = ["up"];
          "navigation.down" = ["down"];
          "navigation.left" = ["left"];
          "navigation.right" = ["right"];
          "navigation.go_to_top" = ["ctrl+home"];
          "navigation.go_to_bottom" = ["ctrl+end"];
          "navigation.page_up" = ["pgup" "shift+up"];
          "navigation.page_down" = ["pgdown" "shift+down"];
          "navigation.tab" = ["tab"];

          "prompt.insert_newline" = ["alt+enter" "ctrl+j" "shift+enter"];
        };

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
