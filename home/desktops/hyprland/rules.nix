{config, ...}: let
  inherit (config.home.sessionVariables) TERMINAL_CLASS;
in {
  wayland.windowManager.hyprland.settings = {
    windowrulev2 =
      [
        "float, class:^(hyprland-share-picker)$"
        "workspace 3, class:^(Electron)$, title:^(BSC)$" # BetterSoundCloud
        "workspace 3, class:^(opensoundcloud)$"

        "noinitialfocus, floating:0, class:^(?!${TERMINAL_CLASS}).*$" # Dont focus tiling windows on startup except $TERMINAL_CLASS
      ]
      ++ map (rule: "${rule}, class:^(xdg-desktop-portal-gtk)$") [
        "float"
        "size 800 600"
        "center 1"
        "dimaround"
      ];
  };
}
