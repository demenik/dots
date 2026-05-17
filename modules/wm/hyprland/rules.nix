{
  wayland.windowManager.hyprland.settings = {
    window_rule = [
      {
        match.class = "^(hyprland-share-picker)$";
        float = true;
      }

      {
        name = "xdg-desktop-portal-gtk";
        match.class = "^(xdg-desktop-portal-gtk)$";

        float = true;
        size = "1000 750";
        center = true;
        dim_around = true;
      }
    ];
  };
}
