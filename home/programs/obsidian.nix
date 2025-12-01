{pkgs, ...}: {
  home.packages = with pkgs; [obsidian];

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace 1, class:^(obsidian)$"
  ];
}
