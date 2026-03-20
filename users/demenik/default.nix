{
  imports = [
    ./wallpaper.nix
  ];

  username = "demenik";

  modules = [
    ../../modules/colors.nix

    ../../modules/wm/hyprland

    ../../modules/services/nextcloud-mount.nix

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
    ../../modules/programs/rofi.nix
    ../../modules/programs/qbittorrent.nix
    ../../modules/programs/libreoffice.nix
    ../../modules/programs/obsidian.nix
    ../../modules/programs/nautilus.nix
    ../../modules/programs/element.nix
    ../../modules/programs/gimp.nix
    ../../modules/programs/aseprite.nix
    ../../modules/programs/screenshot.nix
    ../../modules/programs/anki.nix

    ../../modules/programs/gaming/games/osu.nix
    ../../modules/programs/gaming/games/minecraft.nix

    ../../modules/cli/ai/opencode.nix
    ../../modules/cli/ai/gemini-cli.nix
    ../../modules/cli/bat.nix
  ];
  moduleConfig = {
    wm.input.keyboard.layout = "de";

    colors = {
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
    nextcloudMount.path = ./secrets/nextcloud-mount.sops;
    anki.path = ./secrets/anki.sops;
  };

  nixosConfig = {
    imports = [
      ./i18n.nix
    ];

    users.users.demenik = {
      description = "Dominik";
      extraGroups = ["wheel"];
    };
  };

  homeConfig = {
    imports = [
      ./theme
    ];
  };
}
