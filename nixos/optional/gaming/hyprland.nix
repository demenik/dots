{user, ...}: {
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.windowrulev2 = let
      classes = builtins.concatStringsSep "|" [
        "steam_app_\d+"
        "lutris"
      ];
    in
      map (rule: "${rule}, class:^(${classes})$") [
        "immediate"
        "idleinhibit focus"
        "fullscreen"
      ];
  };
}
