{user, ...}: {
  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.windowrule = let
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
      ++ [
        {
          name = "game-window";
          "match:tag" = "game";

          immediate = true;
          idle_inhibit = "focus";
          fullscreen = true;
          workspace = 1;
          center = true;
        }
      ];
  };
}
