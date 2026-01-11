{pkgs, ...}: {
  home.packages = with pkgs; [
    ryubing
  ];

  wayland.windowManager.hyprland.settings.windowrule = map (rule: "${rule}, match:class ^(Ryujinx)$") [
    "no_blur on"
    "no_shadow on"

    "immediate on"
    "idle_inhibit focus"
    "workspace 1"
    "center on"
  ];
}
