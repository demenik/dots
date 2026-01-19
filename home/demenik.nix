rec {
  headless = {
    pkgs,
    inputs,
    ...
  }: {
    imports = [
      ./global.nix
      ./shells/zsh
      ./editors/nvim

      inputs.stylix.homeModules.stylix
      ./stylix
    ];

    home.file.".face" = {
      source = pkgs.fetchurl {
        url = "https://github.com/demenik.png";
        hash = "sha256-+1ugmn5qeAvijj5Lm3Ye0rW9UEF9OCGxiSMfZKVjxI4=";
      };
    };
  };

  full = {pkgs, ...}: {
    imports = [
      headless

      ./xdg-desktop.nix
      ./accounts

      ./desktops/hyprland
      ./services/kanshi.nix
      ./services/bisync.nix

      ./terminals/kitty
      # ./editors/intellij.nix
      ./editors/godot.nix
      ./programs
    ];

    home.packages = with pkgs; [
      mpvpaper
    ];

    services.swww.enable = true;
  };
}
