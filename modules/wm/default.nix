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
              default = null;
              type = types.nullOr (types.submodule {
                options = {
                  width = mkOption {type = types.int;};
                  height = mkOption {type = types.int;};
                  refresh = mkOption {type = types.nullOr types.float;};
                };
              });
            };
            position = mkOption {
              default = null;
              type = types.nullOr (types.submodule {
                options = {
                  x = mkOption {type = types.int;};
                  y = mkOption {type = types.int;};
                };
              });
            };
            scale = mkOption {
              type = types.nullOr (types.either types.int types.float);
              default = null;
              description = "Monitor scaling";
            };
            transform = mkOption {
              default = null;
              type = types.nullOr (types.submodule {
                options = {
                  rotation = mkOption {
                    type = types.enum [0 90 180 270];
                    default = 0;
                    description = "Rotation counter-clockwise in degrees";
                  };
                  flipped = mkOption {
                    type = types.bool;
                    default = false;
                  };
                };
              });
            };
            bitdepth = mkOption {
              type = types.nullOr (types.enum [8 10]);
              default = 8;
              description = "Colordepth per channel";
            };
            vrr = mkOption {
              type = types.nullOr (types.enum [false true "on-demand"]);
              default = false;
              description = "Variable refresh rate";
            };
            colorMode = mkOption {
              type = types.nullOr (types.enum ["auto" "srgb" "hdr"]);
              default = "auto";
            };
          };
        });
      };
      primaryMonitor = mkOption {
        type = types.nullOr types.attrs;
        readOnly = true;
        description = "The config of the primary monitor (or null if it isn't configured)";
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

      windowrules = mkOption {
        description = "Universal window manager rules";
        default = [];
        type = types.listOf (types.submodule {
          options = {
            matchClass = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Regex or exact string of the window class";
            };
            matchTitle = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Regex or exact string of the window title";
            };

            workspace = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Target workspace (e.g. '1', 'name:web' or 'special')";
            };
            monitor = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Target monitor (e.g. 'DP-1')";
            };

            floating = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Wether the window should be floating";
            };
            center = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Wether the window should be centered (to be used with floating)";
            };
            size = mkOption {
              type = types.nullOr (types.listOf types.int);
              default = null;
              description = "Size of the window: [width height]";
            };
            position = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = null;
              example = ["100%-w-5" "100%-h-5"];
              description = "Position of the window.";
            };
            opacity = mkOption {
              type = types.nullOr (types.either types.float types.int);
              default = null;
              description = "Opacity of the window (0.0 to 1.0).";
            };
            fullscreen = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Wether the window should be fullscreen";
            };
            noInitialFocus = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Wether the window should take focus when opened";
            };
            keepAspectRatio = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Wether the window should maintain its aspect ratio";
            };
            pinned = mkOption {
              type = types.nullOr types.bool;
              default = null;
              description = "Wether this window should be pinned (to be used with floating)";
            };
          };
        });
      };

      binds = mkOption {
        description = "Universal window manager binds";
        default = [];
        type = types.listOf (types.submodule {
          options = {
            modifiers = mkOption {
              type = types.listOf (types.enum [
                "SUPER"
                "SHIFT"
                "ALT"
                "CTRL"
                "MOD4" # Super
                "MOD1" # Alt
              ]);
              default = ["SUPER"];
              example = ["SUPER" "SHIFT"];
              description = "List of modifiers";
            };
            key = mkOption {
              type = types.str;
              example = "Return";
              description = "The key e.g. 'A' or 'Return'";
            };

            exec = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Executes a shell command";
            };
          };
        });
      };
    };
  };

  moduleConfig = {
    lib,
    config,
    ...
  }: {
    wm = {
      primaryMonitor = lib.findFirst (m: m.primary) null config.wm.monitors;
    };
  };
}
