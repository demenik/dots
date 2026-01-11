{
  imports = [
    ../programs/games
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-1, 1920x1080@143.98, 0x0, 1"
      "DP-1, 1920x1080@60, 1920x0, 1, transform, 1"
    ];
    workspace =
      [
        "2, monitor:DP-1, default:true, persistent:true"
        "3, monitor:DP-1"
        "1, monitor:HDMI-A-1, default:true, persistent:true"

        "m[DP-1], layoutopt:orientation:top"
      ]
      ++ map (i: "${builtins.toString i}, monitor:HDMI-A-1") [4 5 6 7 8 9 10];
    windowrule = [
      "workspace 3, match:class ^(vesktop)$"
    ];
  };
}
