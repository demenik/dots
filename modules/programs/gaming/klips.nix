{
  name = "klips";

  moduleConfig = {
    lib,
    config,
    ...
  }: {
    wm.binds = [
      {
        modifiers = [];
        key = "F9";
        exec = "klips --capture";
      }
    ];

    programs = lib.optionalAttrs (config.programs ? noctalia) {
      noctalia.plugins = lib.mkIf (config.programs.noctalia.plugins ? privacy-indicator) {
        privacy-indicator.micFilterRegexes = [
          "^gsr-.*$"
        ];
      };
    };
  };

  nixos = {
    programs.gpu-screen-recorder.enable = true;
  };

  home = {
    inputs,
    config,
    ...
  }: {
    imports = [inputs.klips.homeManagerModules.default];

    programs.klips = {
      enable = true;
      autostart.enable = true;

      settings = {
        keybind.primary = "F9";

        recorder = {
          fps = 60;
          codec = "auto";
          monitor = null;
          frame_mode = "vfr";

          audio_tracks = [
            {
              source = "sink:game_audio";
              label = "Game Audio";
              enabled = true;
            }
            {
              source = "sink:voice_chat";
              label = "Voice Chat";
              enabled = true;
            }
            {
              source = "default_input";
              label = "Microphone";
              enabled = true;
            }
          ];

          audio_sinks = {
            game_audio.extra_app_names = [];
            voice_chat.app_names = ["vesktop"];
          };
        };

        storage = {
          clips_dir = "${config.home.homeDirectory}/Videos/klips";
          organize_by = "ByDate";
          replay_duration_secs = 60;
          size_unit = "Binary";
        };

        integration = {
          cs2.gsi.gsi_port = 3000;
          manual_games = [];
        };

        debounce_ms = 500;
      };
    };
  };
}
