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
        workspace = "1";
      }
      {
        matchClass = "steam";
        matchTitle = "Sign in to Steam|Launching...";

        floating = true;
        center = true;
        noInitialFocus = true;
      }
    ];
  };

  nixos = {
    pkgs,
    lib,
    ...
  }: let
    protonBuilds = import ./proton pkgs;
  in {
    nixpkgs.config.allowUnfreePredicate = pkg:
      builtins.elem (lib.getName pkg) [
        "steam"
        "steam-unwrapped"
      ];

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
        protonBuilds.dwproton
      ];
    };

    programs.gamescope.enable = true;
    hardware.steam-hardware.enable = true;
  };
}
