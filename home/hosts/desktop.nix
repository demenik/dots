{
  imports = [
    ../programs/games
  ];

  wayland.windowManager.hyprland.settings = {
    monitor = [
      "HDMI-A-1, 1920x1080@143.98, 0x0, 1"
      "DP-1, 1920x1080@60, 1920x0, 1, transform, 1"
      "HDMI-A-2, 4096x2160@120, -4096x0, 2, bitdepth, 10, cm, hdr, vrr, 1"
    ];
    workspace =
      [
        "2, monitor:DP-1, default:true, persistent:true"
        "3, monitor:DP-1"
        "1, monitor:HDMI-A-1, default:true, persistent:true"
        "10, monitor:HDMI-A-2, default:true, persistent:true"

        "m[DP-1], layoutopt:orientation:top"
      ]
      ++ map (i: "${toString i}, monitor:HDMI-A-1") [4 5 6 7 8 9];
  };
}
