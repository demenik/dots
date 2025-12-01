{pkgs, ...}: {
  home.packages = with pkgs; [
    overskride
  ];

  wayland.windowManager.hyprland.settings.windowrulev2 = map (rule: "${rule}, class:^(io.github.kaii_lb.Overskride)$") [
    "float"
    "size 850 650"
    "center"
  ];
}
