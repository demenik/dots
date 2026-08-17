{
  name = "steam";

  modules = [
    ../../wm
    ./default.nix
    ./mangohud.nix
  ];
  moduleConfig = {
    wm.windowrules = [
      {
        matchClass = "steam";
        matchTitle = "Sign in to Steam|Launching...";

        floating = true;
        center = true;
        noInitialFocus = true;
      }
    ];

    programs.gaming.wrapper.games = {
      # CS2
      "steam:730" = {
        gamescope = {
          enable = true;
          args = {
            w = "1440";
            h = "1080";
            S = "stretch";

            # https://github.com/ValveSoftware/gamescope/issues/1636#issuecomment-2568139933
            backend = "sdl";

            force-grab-cursor = true;
            hdr-enabled = false;
          };
        };
        env = {
          SDL_VIDEO_MINIMIZE_ON_FOCUS_LOSS = "0";
          SDL_VIDEODRIVER = "x11";
          SDL_AUDIO_DRIVER = "pipewire";
        };
        extraArgs = ["+mat_disable_fancy_blending 1"];
      };

      # Overwatch
      "steam:2357570" = {
        gamescope = {
          enable = true;
          args = {
            force-grab-cursor = true;
            hdr-enabled = false;
          };
        };
        env = {
          DXVK_CONFIG = "\"dxvk.trackPipelineLifetime = True;\"";
          __GL_SHADER_DISK_CACHE_SKIP_CLEANUP = "1";
          __GL_SHADER_DISK_CACHE_SIZE = "10737418240";
          PROTON_LOCAL_SHADER_CACHE = "1";
          DXVK_ASYNC = "1";
        };
      };
    };
  };

  overlays.both = [
    (final: prev: {
      dwproton = final.callPackage ./proton/dwproton.nix {};
    })
  ];

  nixos = {
    inputs,
    pkgs,
    config,
    ...
  }: {
    nixpkgs.overlays = [
      inputs.millennium.overlays.default
    ];

    programs.steam = {
      enable = true;
      package = pkgs.millennium-steam.override {
        extraPkgs = _: [config.programs.gaming.wrapper.script];
      };

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;

      extest.enable = true;
      protontricks.enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        dwproton
      ];
    };

    programs.gamescope.enable = true;
    hardware.steam-hardware.enable = true;
  };

  home = {
    theme.templates.steam.enable = true;
  };
}
