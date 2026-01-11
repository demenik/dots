{
  user,
  pkgs,
  lib,
  ...
}: {
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = true;
      };
    };

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extest.enable = true;
    protontricks.enable = true;

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  programs.gamescope.enable = true;

  hardware.steam-hardware.enable = true;

  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.windowrulev2 =
      [
        "workspace 1, match:class ^(steam)$"
      ]
      ++ map ({
        rule,
        title,
      }: "${rule}, match:class ^(steam)$, match:title ^(${title})$")
      (lib.cartesianProduct {
        rule = ["float" "center" "noinitialfocus"];
        title = ["Sign in to Steam" "Launching..."];
      });
  };
}
