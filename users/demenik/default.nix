{
  imports = [
    ./wallpaper.nix
  ];

  username = "demenik";

  modules = [
    ../../modules/colors.nix

    ../../modules/wm/hyprland

    ../../modules/services/nextcloud-mount.nix
    ../../modules/services/vpn/openvpn.nix

    ../../modules/terminal/kitty.nix
    ../../modules/shell/zsh
    ../../modules/shell/.tmux

    ../../modules/cli/sudo-rs.nix
    ../../modules/cli/uutils.nix
    ../../modules/cli/direnv.nix

    ../../modules/editors/nvim
    ../../modules/editors/godot.nix

    ../../modules/browser/librewolf

    ../../modules/programs/vesktop.nix
    ../../modules/programs/thunderbird.nix
    ../../modules/programs/spotify.nix
    ../../modules/programs/qbittorrent.nix
    ../../modules/programs/libreoffice.nix
    ../../modules/programs/obsidian.nix
    ../../modules/programs/nautilus.nix
    ../../modules/programs/element.nix
    ../../modules/programs/gimp.nix
    ../../modules/programs/aseprite.nix
    ../../modules/programs/anki.nix
    ../../modules/programs/inkscape.nix
    ../../modules/programs/vlc.nix
    ../../modules/programs/bisq.nix

    ../../modules/programs/gaming/games/osu.nix
    ../../modules/programs/gaming/games/minecraft.nix

    ../../modules/cli/ai/opencode.nix
    ../../modules/cli/ai/gemini-cli.nix
    ../../modules/cli/bat.nix
    ../../modules/cli/btop.nix
    ../../modules/cli/zip.nix
    ../../modules/cli/eza.nix
    ../../modules/cli/fd.nix
    ../../modules/cli/utils.nix
    ../../modules/cli/ssh.nix
    ../../modules/cli/ripgrep.nix
    ../../modules/cli/zoxide.nix
    ../../modules/cli/docker.nix
    ../../modules/cli/adb.nix
    ../../modules/cli/just.nix
  ];
  moduleConfig = {
    pkgs,
    lib,
    config,
    ...
  }: {
    wm.input.keyboard.layout = "de";

    wm.binds = [
      {
        modifiers = ["SUPER"];
        key = "s";
        exec = lib.getExe (pkgs.writeShellApplication {
          name = "start-daily-apps";
          runtimeInputs = with pkgs; [procps];
          text = ''
            run_if_not_running() {
              if ! pgrep "$1" >/dev/null; then
                "$2" &
              fi
            }

            run_if_not_running "${config.browser.windowClass}" "${config.browser.command}"
            run_if_not_running "vesktop" "${lib.getExe pkgs.vesktop}"
            run_if_not_running "spotify" "${lib.getExe config.programs.spicetify.spicedSpotify}"
          '';
        });
      }
    ];

    colors = {
      accent = config.colors.base0E;

      base00 = "1e1e2e";
      base01 = "181825";
      base02 = "313244";
      base03 = "45475a";
      base04 = "585b70";
      base05 = "cdd6f4";
      base06 = "f5e0dc";
      base07 = "b4befe";
      base08 = "f38ba8";
      base09 = "fab387";
      base0A = "f9e2af";
      base0B = "a6e3a1";
      base0C = "94e2d5";
      base0D = "89b4fa";
      base0E = "cba6f7";
      base0F = "f2cdcd";
    };
  };

  secrets = {
    nextcloudMount.path = ./secrets/nextcloud-mount.sops.yaml;
    anki.path = ./secrets/anki.sops.yaml;
    openvpn.path = ./secrets/openvpn.sops.yaml;
    wakatime.path = ./secrets/wakatime.sops.yaml;
    gitea-token.path = ./secrets/gitea.sops.yaml;

    mcp-context7 = {
      path = ./secrets/mcp.sops.yaml;
      key = "context7";
    };
  };

  nixosConfig = {
    imports = [
      ./i18n.nix
    ];

    users.users.demenik = {
      description = "Dominik";
      extraGroups = ["wheel"];
    };

    home-manager.backupFileExtension = "backup";
  };

  homeConfig = {
    imports = [
      ./theme
    ];

    programs.home-manager.enable = true;
  };
}
