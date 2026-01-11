{pkgs, ...}: {
  home.packages = with pkgs; [
    overskride
  ];

  wayland.windowManager.hyprland.settings.windowrule = map (rule: "${rule}, match:class ^(io.github.kaii_lb.Overskride)$") [
    "float on"
    "size 850 650"
    "center on"
  ];
}
