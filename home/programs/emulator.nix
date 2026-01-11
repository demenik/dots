{
  wayland.windowManager.hyprland.settings.windowrule = map (rule: "${rule}, match:class ^(Emulator)$") [
    "float on"
    "keep_aspect_ratio on"
    "pin on"
  ];
}
