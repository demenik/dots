{
  name = "vice";

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
          rev = "v1.3.4";
          hash = "sha256-zZv3DJf0gWFTu/jisVkgi+fMlRAHYo+j2xXH1SIaGqM=";
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
          "--prefix PATH : ${final.lib.makeBinPath (with final; [
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
        clip_duration = 30;
        fps = 60;

        encoder = "auto";
        backend = "auto";
        container = "mkv";

        capture_audio = true;
        capture_microphone = true;
        gsr_audio_source = "app-inverse:spotify";
        audio_tracks = [
          "app-inverse:vesktop"
          "default_input"
          "app:vesktop"
        ];
        audio_tracks_mix_first = true;
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
        ExecStart = "${lib.getExe pkgs.vice} start";
        Restart = "always";
        RestartSec = 3;
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
