{
  wayland.windowManager.hyprland.settings.windowrulev2 = map (rule: "${rule}, class:^(Emulator)$") [
    "float"
    "keepaspectratio"
    "pin"
  ];
}
