{pkgs, ...}: {
  home.packages = with pkgs; [obsidian];

  wayland.windowManager.hyprland.settings.windowrule = [
    "workspace 1, match:class ^(obsidian)$"
  ];
}
