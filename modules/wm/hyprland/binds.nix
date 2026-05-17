{
  pkgs,
  lib,
  ...
}: {
  wayland.windowManager.hyprland.settings = let
    mkLua = lib.generators.mkLuaInline;
    exec = cmd: "hl.dsp.exec_cmd('${cmd}')";

    mkBind = {
      keys,
      dispatcher,
      opts ? {},
    }: {
      _args = [
        keys
        (mkLua dispatcher)
      ] ++ (if opts == {} then [] else [ opts ]);
    };

    numbers = [1 2 3 4 5 6 7 8 9];
    workspace = num: mkBind {
      keys = "SUPER + ${toString num}";
      dispatcher = "hl.dsp.focus({ workspace = ${toString num} })";
    };
    move-to-workspace = num: mkBind {
      keys = "SUPER + SHIFT + ${toString num}";
      dispatcher = "hl.dsp.window.move({ workspace = ${toString num} })";
    };

    volume-step = 5;
    brightness-step = 5;
    volume-cmd = "${lib.getExe' pkgs.wireplumber "wpctl"} set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ ${toString volume-step}%";
    brightness-cmd = "${lib.getExe pkgs.brightnessctl} set ${toString brightness-step}%";
  in {
    bind =
      [
        (mkBind { keys = "SUPER + SHIFT + Q"; dispatcher = "hl.dsp.exit()"; })
        (mkBind { keys = "SUPER + X"; dispatcher = "hl.dsp.window.close()"; })
        (mkBind { keys = "SUPER + T"; dispatcher = "hl.dsp.window.float({ action = 'toggle' })"; })
        (mkBind { keys = "SUPER + SHIFT + P"; dispatcher = "hl.dsp.window.pin()"; })
        (mkBind { keys = "SUPER + F"; dispatcher = "hl.dsp.window.fullscreen({ mode = 'fullscreen' })"; })
        (mkBind { keys = "SUPER + M"; dispatcher = "hl.dsp.window.fullscreen({ mode = 'maximized' })"; })
        (mkBind { keys = "SUPER + SHIFT + F"; dispatcher = "hl.dsp.window.fullscreen_state({ internal = -1, client = 2 })"; })
        (mkBind { keys = "SUPER + 0"; dispatcher = "hl.dsp.focus({ workspace = 10 })"; })
        (mkBind { keys = "SUPER + SHIFT + 0"; dispatcher = "hl.dsp.window.move({ workspace = 10 })"; })

        # Mouse binds
        (mkBind { keys = "SUPER + mouse:272"; dispatcher = "hl.dsp.window.drag()"; opts = { mouse = true; }; })
        (mkBind { keys = "SUPER + mouse:273"; dispatcher = "hl.dsp.window.resize()"; opts = { mouse = true; }; })

        # Multimedia keys
        (mkBind { keys = "XF86MonBrightnessUp"; dispatcher = exec "${brightness-cmd}+"; opts = { locked = true; repeating = true; }; })
        (mkBind { keys = "XF86MonBrightnessDown"; dispatcher = exec "${brightness-cmd}-"; opts = { locked = true; repeating = true; }; })
        (mkBind { keys = "XF86AudioRaiseVolume"; dispatcher = exec "${volume-cmd}+"; opts = { locked = true; repeating = true; }; })
        (mkBind { keys = "XF86AudioLowerVolume"; dispatcher = exec "${volume-cmd}-"; opts = { locked = true; repeating = true; }; })
        (mkBind { keys = "XF86AudioMute"; dispatcher = exec "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle"; opts = { locked = true; repeating = true; }; })
        (mkBind { keys = "XF86AudioMicMute"; dispatcher = exec "${lib.getExe' pkgs.wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; opts = { locked = true; repeating = true; }; })

        # Playerctl
        (mkBind { keys = "XF86AudioPlay"; dispatcher = exec "${lib.getExe pkgs.playerctl} play-pause"; opts = { locked = true; }; })
        (mkBind { keys = "XF86AudioNext"; dispatcher = exec "${lib.getExe pkgs.playerctl} next"; opts = { locked = true; }; })
        (mkBind { keys = "XF86AudioPrev"; dispatcher = exec "${lib.getExe pkgs.playerctl} previous"; opts = { locked = true; }; })
      ]
      ++ map move-to-workspace numbers
      ++ map workspace numbers
      ++ (import ./vim-binds.nix {inherit lib;});
  };

  home.packages = with pkgs; [brightnessctl];
  services.playerctld.enable = true;
}
