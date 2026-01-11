{config, ...}: let
  inherit (config.home.sessionVariables) TERMINAL_CLASS;
in {
  wayland.windowManager.hyprland.settings = {
    windowrule =
      [
        "float on, match:class ^(hyprland-share-picker)$"
        "workspace 3, match:class ^(Electron)$, match:title ^(BSC)$" # BetterSoundCloud
        "workspace 3, match:class ^(opensoundcloud)$"

        "no_initial_focus on, match:float on, match:class ^(?!${TERMINAL_CLASS}).*$" # Dont focus tiling windows on startup except $TERMINAL_CLASS
      ]
      ++ map (rule: "${rule}, match:class ^(xdg-desktop-portal-gtk)$") [
        "float on"
        "size 800 600"
        "center on"
        "dim_around on"
      ];
  };
}
