{
  pkgs,
  config,
  ...
}: {
  home.packages = with pkgs; [
    nautilus
    nautilus-python
    nautilus-open-any-terminal
  ];

  dconf.settings."com/github/Stunkymonkey/nautilus-open-any-terminal" = {
    terminal = "kitty";
    new-tab = true;
    flatpak = "system";
  };

  gtk = {
    enable = true;
    gtk3.bookmarks = let
      home = config.home.homeDirectory;
    in [
      "file:///"
      "file://${home}/Downloads"
      "file://${home}/dev"
      "file://${home}/dots"
      "file://${home}/uni"
      "file://${home}/Documents"
    ];
  };

  wayland.windowManager.hyprland.settings.bind = [
    "SUPER, e, exec, nautilus"
  ];
}
