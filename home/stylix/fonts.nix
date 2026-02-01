{
  pkgs,
  lib,
  ...
}: {
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
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu

    noto-fonts-cjk-sans

    nerd-fonts.symbols-only
  ];

  fonts.fontconfig = {
    defaultFonts = lib.mkForce rec {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Sans Mono CJK JP"
        "Noto Sans CJK SC"
        "Noto Sans CJK KR"
        "Twitter Color Emoji"
      ];
      sansSerif = [
        "Ubuntu Nerd Font"
        "Noto Sans CJK JP"
        "Noto Sans CJK SC"
        "Noto Sans CJK KR"
        "Twitter Color Emoji"
      ];
      serif = sansSerif;
      emoji = ["Twitter Color Emoji"];
    };
  };
}
