{
  imports = [
    ../programs/games
  ];

  wayland.windowManager.hyprland.settings = {
    monitorv2 = [
      {
        output = "HDMI-A-1";
        mode = "1920x1080@143.98";
        position = "0x0";
        scale = 1;
      }
      {
        output = "DP-1";
        mode = "1920x1080@60";
        position = "1920x0";
        scale = 1;
        transform = 1;
      }
      {
        output = "HDMI-A-2";
        mode = "4096x2160@120";
        position = "-4096x0";
        scale = 2;
        bitdepth = 10;
        cm = "hdr";
        vrr = 1;
      }
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
