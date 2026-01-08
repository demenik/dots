{pkgs, ...}: {
  home.packages = with pkgs; [
    ryubing
  ];

  wayland.windowManager.hyprland.settings.windowrulev2 = map (rule: "${rule}, class:^(Ryujinx)$") [
    "noblur"
    "noshadow"

    "immediate"
    "idleinhibit focus"
    "workspace 1"
    "center"
  ];
}
