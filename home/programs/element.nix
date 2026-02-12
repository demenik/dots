{pkgs, ...}: {
  home.packages = with pkgs; [
    element-desktop
  ];

  wayland.windowManager.hyprland.settings.windowrule = [
    "workspace 3, match:class ^(Element)$"
  ];
}
