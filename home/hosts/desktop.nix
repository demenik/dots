{
  wayland.windowManager.hyprland.settings = {
    env = [
      "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      "GBM_BACKEND,nvidia-drm"
      "LIBVA_DRIVER_NAME,nvidia"
    ];

    monitor = [
      "HDMI-A-1,preferred,auto,1"
      "DP-3,1920x1080@60,auto,1,transform,0,workspace,2"
    ];
  };
}
