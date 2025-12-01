{pkgs, ...}: {
  home.packages = with pkgs; [
    nmgui
  ];

  wayland.windowManager.hyprland.settings.windowrulev2 = map (rule: "${rule}, class:^(com.network.manager)$") [
    "float"
    "size 500 600"
    "center"
  ];
}
