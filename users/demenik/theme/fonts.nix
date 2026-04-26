{pkgs, ...}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    nerd-fonts.ubuntu
    noto-fonts
    noto-fonts-cjk-sans
    twitter-color-emoji
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts = rec {
      monospace = [
        "JetBrainsMono Nerd Font"
        "Noto Sans"
        "Noto Sans Mono CJK JP"
        "Noto Sans Mono CJK SC"
        "Noto Sans Mono CJK KR"
      ];
      sansSerif = [
        "Ubuntu Nerd Font"
        "Noto Sans"
        "Noto Sans CJK JP"
        "Noto Sans CJK SC"
        "Noto Sans CJK KR"
      ];
      serif = sansSerif;
      emoji = ["Twitter Color Emoji"];
    };
  };

  gtk.font = {
    name = "Ubuntu Nerd Font";
    package = pkgs.nerd-fonts.ubuntu;
  };
}
