{
  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    c = config.colors.withHashtag;
    colors =
      if config.theme.type == "colorScheme"
      then {
        running = c.base0A;
        ok = c.base0B;
        bad = c.base08;
      }
      else {
        running = "{{colors.primary.default.hex}}";
        ok = "{{colors.tertiary.default.hex}}";
        bad = "{{colors.error.default.hex}}";
      };

    # Last line of oh-my-posh prompt (modules/shell/zsh/prompt.nix)
    promptRegex = ''^\x{e6b1}\s*$'';

    watcher = pkgs.buildGoModule {
      pname = "rebuild-notify";
      version = "0.1.0";
      src = ./src;
      vendorHash = null;
      meta.mainProgram = "rebuild-notify";
    };

    manifest = (pkgs.formats.toml {}).generate "herdr-plugin.toml" {
      id = "dots.rebuild-notify";
      name = "Rebuild notify";
      version = "0.1.0";
      min_herdr_version = "0.9.3";
      platforms = ["linux"];
      startup = [
        {
          command = [
            pkgs.runtimeShell
            "-c"
            "exec ${pkgs.util-linux}/bin/setsid -f ${lib.getExe watcher} --prompt ${lib.escapeShellArg promptRegex} </dev/null >/dev/null 2>&1"
          ];
        }
      ];
    };

    plugin = pkgs.runCommand "herdr-rebuild-notify" {} ''
      mkdir -p "$out"
      cp "${manifest}" "$out"/herdr-plugin.toml
    '';

    rule = state: style: {equals = state;} // style;
  in {
    programs.herdr = {
      plugins = [plugin];

      settings.ui.sidebar.spaces.rows = [
        [
          "state_icon"
          "workspace"
          {
            token = "$rebuild";
            rules =
              map (s: rule s {fg = colors.running;}) ["building" "copying" "activating" "bootloader"]
              ++ [
                (rule "sudo" {
                  fg = colors.bad;
                  bold = true;
                })
                (rule "failed" {fg = colors.bad;})
                (rule "done" {fg = colors.ok;})
              ];
          }
        ]
        ["branch" "git_status"]
      ];
    };
  };
}
