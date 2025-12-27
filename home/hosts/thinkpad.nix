{
  imports = [
    ../services/kanshi.nix
  ];

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace 4, class:^()"
  ];
}
