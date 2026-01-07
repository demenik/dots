{pkgs, ...}: {
  home.packages = with pkgs; [
    ryubing
  ];

  wayland.windowManager.hyprland.settings.windowrulev2 = map (rule: "${rule}, class:^(Ryujinx)$") [
    "noblur"
    "noshadow"
  ];
}
