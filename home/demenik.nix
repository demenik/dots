{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./global.nix
    ./xdg-desktop.nix
    ./accounts

    ./desktops/hyprland

    ./services/kanshi.nix
    ./services/bisync.nix

    ./shells/zsh
    ./terminals/kitty

    ./programs
    ./editors/nvim
    ./editors/intellij.nix
    ./editors/godot.nix

    inputs.stylix.homeModules.stylix
    ./stylix
  ];

  home.file.".face" = {
    source = pkgs.fetchurl {
      url = "https://github.com/demenik.png";
      hash = "sha256-+1ugmn5qeAvijj5Lm3Ye0rW9UEF9OCGxiSMfZKVjxI4=";
    };
  };

  home.packages = with pkgs; [
    mpvpaper
  ];

  services.swww.enable = true;
}
