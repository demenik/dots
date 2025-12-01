{pkgs, ...}: {
  wayland.windowManager.hyprland = {
    settings = {
      bind = let
        numbers = [1 2 3 4 5 6 7 8 9];
        workspace = num: "SUPER, ${toString num}, workspace, ${toString num}";
        move-to-workspace = num: "SUPER SHIFT, ${toString num}, movetoworkspace, ${toString num}";
      in
        [
          "SUPER SHIFT, q, exit"

          "SUPER, x, killactive"
          "SUPER, t, togglefloating"
          "SUPER SHIFT, p, pin"
          "SUPER, f, fullscreen, 0"
          "SUPER, m, fullscreen, 1"
          "SUPER SHIFT, f, fullscreenstate, -1 2"

          "SUPER, 0, workspace, 10"
          "SUPER SHIFT, 0, movetoworkspace, 10"
        ]
        ++ map move-to-workspace numbers
        ++ map workspace numbers;

      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];

      binde = let
        volume-value = 5;
        brightness-value = 5;
        volume-cmd = "wpctl set-volume -l 1.5 @DEFAULT_AUDIO_SINK@ ${toString volume-value}%";
      in [
        ",XF86MonBrightnessUp, exec, light -A ${toString brightness-value}"
        ",XF86MonBrightnessDown, exec, light -U ${toString brightness-value}"
        # TODO: these dont work on the ThinkPad

        ",XF86AudioRaiseVolume, exec, ${volume-cmd}+"
        ",XF86AudioLowerVolume, exec, ${volume-cmd}-"
        ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ];

      bindl = [
        ",XF86AudioPlay, exec, playerctl play-pause"
        ",XF86AudioNext, exec, playerctl next"
        ",XF86AudioPrev, exec, playerctl previous"
      ];
    };

    extraConfig = import ./vim-binds.nix + import ./app-binds.nix;
  };

  services.playerctld.enable = true;
  home.packages = with pkgs; [light];
}
