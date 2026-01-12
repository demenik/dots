{
  wayland.windowManager.hyprland.settings.windowrule = [
    {
      name = "emulator";
      "match:class" = "^(Emulator)$";

      float = true;
      keep_aspect_ratio = true;
      pin = true;
    }
  ];
}
