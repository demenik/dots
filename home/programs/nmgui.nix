{pkgs, ...}: {
  home.packages = with pkgs; [
    nmgui
  ];

  wayland.windowManager.hyprland.settings.windowrule = map (rule: "${rule}, match:class ^(com.network.manager)$") [
    "float on"
    "size 500 600"
    "center on"
  ];
}
