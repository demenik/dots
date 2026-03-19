{lib, ...}: {
  name = "window-manager";
  moduleOptions = with lib; {
    wm = {
      monitors = mkOption {
        description = "Configuration for monitors";
        default = [];
        type = types.listOf (types.submodule {
          options = {
            output = mkOption {
              type = types.str;
              example = "DP-1";
              description = "Name of video output (e.g. DP-1, eDP-1, HDMI-A-1)";
            };
            primary = mkOption {
              type = types.bool;
              default = false;
              description = "Wether this should be the primary monitor";
            };
            mode = mkOption {
              type = types.str;
              example = "1920x1080@60";
              description = "Resolution and refresh rate";
            };
            position = mkOption {
              type = types.str;
              default = "0x0";
              description = "Position of the monitor";
            };
            scale = mkOption {
              type = types.either types.int types.float;
              default = 1.0;
              description = "Monitor scaling";
            };
            transform = mkOption {
              type = types.enum [0 1 2 3];
              default = 0;
              description = "Rotation: 0=normal, 1=90, 2=180, 3=270 degrees";
            };
            bitdepth = mkOption {
              type = types.enum [8 10];
              default = 8;
              description = "Colordepth per channel";
            };
            vrr = mkOption {
              type = types.enum [0 1 2];
              default = 0;
              description = "Variable refresh rate: 0 (off), 1 (on), 2 (fullscreen only)";
            };
            colorMode = mkOption {
              type = types.enum ["auto" "srgb" "hdr"];
              default = "auto";
            };
          };
        });
      };

      input = {
        keyboard = {
          layout = mkOption {
            type = types.str;
            default = "en";
            description = "The primary keyboard layout";
          };
          variant = mkOption {
            type = types.str;
            default = "nodeadkeys";
            description = "Keyboard layout variant";
          };
        };

        touchpad = {
          tapToClick = mkOption {
            type = types.bool;
            default = true;
            description = "Activate tap-to-click for touchpad";
          };
          naturalScroll = mkOption {
            type = types.bool;
            default = true;
            description = "Enable natural scrolling (inverted)";
          };
        };
      };
    };
  };
}
