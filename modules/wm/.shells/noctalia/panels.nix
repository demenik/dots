{
  lib,
  config,
  ...
}: let
  monitors =
    if config.wm.primaryMonitor != null
    then [config.wm.primaryMonitor.output]
    else [];
in {
  programs.noctalia-shell.settings = {
    controlCenter = {
      position = "close_to_bar_button";
      diskPath = "/";

      cards =
        map (id: {
          inherit id;
          enabled = true;
        }) [
          "profile-card"
          "media-sysmon-card"
          "weather-card"
          "shortcuts-card"
          "audio-card"
          "brightness-card"
        ];

      shortcuts = {
        left = [
          {id = "Network";}
          {id = "Bluetooth";}
          {id = "NoctaliaPerformance";}
        ];
        right = [
          {id = "PowerProfile";}
          {id = "KeepAwake";}
          {id = "NightLight";}
        ];
      };
    };
    sessionMenu = {
      position = "center";
      showHeader = true;
      showKeybinds = true;

      largeButtonsStyle = false;
      largeButtonsLayout = "single-row";

      enableCountdown = true;
      countdownDuration = 10000;

      powerOptions =
        lib.imap1
        (i: opt: {
          inherit (opt) action;
          enabled = opt.enabled or true;
          keybind = opt.keybind or (toString i);
          command = opt.command or "";
          countdownEnabled = opt.countdown or true;
        })
        [
          {action = "lock";}
          {action = "suspend";}
          {action = "hibernate";}
          {action = "reboot";}
          {action = "logout";}
          {action = "shutdown";}
          {action = "rebootToUefi";}
          {
            action = "userspaceReboot";
            enabled = false;
          }
        ];
    };

    desktopWidgets.enabled = false;
    dock.enabled = false;

    osd = {
      enabled = true;
      enabledTypes = [0 1 2 3];
      location = "top_right";
      inherit monitors;
      overlayLayer = true;

      autoHideMs = 2000;
      backgroundOpacity = 0.825;
    };
  };
}
