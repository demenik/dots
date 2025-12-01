{pkgs, ...}: {
  stylix.fonts = rec {
    sansSerif = {
      package = pkgs.nerd-fonts.ubuntu;
      name = "Ubuntu Nerd Font";
    };

    serif = sansSerif;

    monospace = {
      package = pkgs.nerd-fonts.jetbrains-mono;
      name = "JetBrainsMono Nerd Font";
    };

    emoji = {
      package = pkgs.twemoji-color-font;
      name = "Twitter Color Emoji";
    };
  };

  home.packages = with pkgs; [
    noto-fonts-cjk-sans
  ];

  fonts.fontconfig.defaultFonts = let
    font = ["Ubuntu Nerd Font" "Noto Sans CJK"];
  in {
    sansSerif = font;
    serif = font;
  };
}
