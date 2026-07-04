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
  };

  overlays.both = [
    (final: prev: {
      dwproton = final.callPackage ./proton/dwproton.nix {};
    })
  ];

  nixos = {pkgs, ...}: {
    programs.steam = {
      enable = true;
      package = pkgs.steam.override {
        extraEnv.MANGOHUD = true;
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
}
