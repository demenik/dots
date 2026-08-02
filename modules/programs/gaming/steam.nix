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
      "steam:730".gamescope = {
        enable = true;
        args = {
          w = "1440";
          h = "1080";
          S = "stretch";

          force-grab-cursor = true;
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
        extraEnv.MANGOHUD = true;
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
