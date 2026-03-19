{
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      "float on, match:class ^(hyprland-share-picker)$"

      {
        name = "xdg-desktop-portal-gtk";
        "match:class" = "^(xdg-desktop-portal-gtk)$";

        float = true;
        size = "1000 750";
        center = true;
        dim_around = true;
      }
    ];
  };
}
