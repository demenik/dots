{
  name = "vice";

  moduleConfig = {
    lib,
    config,
    ...
  }: {
    programs = lib.mkIf (config.programs ? noctalia) {
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

  overlays.home = [
    (final: prev: {
      vice = final.python3Packages.buildPythonApplication {
        pname = "vice";
        version = "1.3.4";
        pyproject = true;

        src = final.fetchFromGitHub {
          owner = "eklonofficial";
          repo = "Vice";
          rev = "1bf45adaaafe8caf16ed6b3041739faa3009adf0";
          hash = "sha256-F+zkl4Lceol4tyfy9e5foOx5CKxdR3BjQxJZl06gbjM=";
        };

        nativeBuildInputs = with final.python3Packages; [
          setuptools
          wheel
          final.makeWrapper
        ];

        propagatedBuildInputs = with final.python3Packages; [
          evdev
          aiohttp
          click
          psutil
          pywebview
          tomli-w
          pyqt6-webengine
          qtpy
        ];

        makeWrapperArgs = [
          "--prefix PATH : /run/wrappers/bin:${final.lib.makeBinPath (with final; [
            ffmpeg
            gpu-screen-recorder
            wl-clipboard
            xclip
          ])}"
        ];

        meta = {
          description = "Medal.tv-style game clip recorder for Linux";
          homepage = "https://github.com/eklonofficial/Vice";
          mainProgram = "vice";
        };
      };
    })
  ];

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    toml = pkgs.formats.toml {};

    display =
      if config.wm.primaryMonitor != null
      then config.wm.primaryMonitor.output
      else null;
  in {
    home.packages = [
      pkgs.vice
    ];

    xdg.configFile."vice/config.toml".source = toml.generate "vice-config.toml" (lib.filterAttrs (n: v: v != null) {
      recording = {
        inherit display;
        clip_duration = 60;
        fps = 60;

        encoder = "auto";
        backend = "auto";
        container = "mkv";

        capture_audio = true;
        capture_microphone = true;
        audio_tracks = [
          "app-inverse:spotify|app-inverse:Chromium" # game audio
          "default_input" # microphone
          "app:Chromium" # vesktop
        ];
        audio_tracks_mix_first = false;
      };

      hotkeys.clip = "KEY_F9";

      output = {
        directory = "/mnt/SSD/Vice";
        tag_clips_with_game = true;
      };

      sharing.port = 8766;
      discord.enabled = false;
    });

    systemd.user.services.vice-daemon = {
      Unit = {
        Description = "Vice Replay Clipping Daemon";
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
      };

      Service = {
        Type = "simple";
        ExecStart = "${lib.getExe pkgs.vice} start --no-open-ui";
        Restart = "always";
        RestartSec = 3;
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
