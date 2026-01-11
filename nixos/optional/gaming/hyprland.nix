{user, ...}: {
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.windowrulev2 = let
      gameClasses = [
        "steam_app_\\d+"
        "gamescope"
        "lutris"
        "osu!"
        "Minecraft.*"
        "PMKM2"
      ];
    in
      map (class: "tag +game, match:class ^(${class})$") gameClasses
      ++ map (rule: "${rule}, tag:game") [
        "immediate"
        "idleinhibit focus"
        "fullscreen"
        "workspace 1"
        "center"
      ];
  };
}
