{pkgs, ...}: {
  imports = [
    ./cursor.nix
    ./fonts.nix
    ./targets.nix
  ];

  stylix = {
    enable = true;

    base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
    polarity = "dark";
    override = {
      # swap base0E with base0D, so that mauve is the main accent
      base0D = "cba6f7"; # base0E
      base0E = "89b4fa"; # base0D
    };

    icons = {
      enable = true;
      dark = "Papirus";
      package = pkgs.papirus-icon-theme;
    };

    opacity = {
      terminal = 0.9;
      applications = 0.9;
      desktop = 0.9;
      popups = 0.9;
    };
  };
}
