{
  user,
  pkgs,
  ...
}: let
  protonBuilds = import ./proton {inherit pkgs;};
in {
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
      protonBuilds.dwproton
    ];
  };

  programs.gamescope.enable = true;

  hardware.steam-hardware.enable = true;

  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.windowrule =
      [
        "workspace 1, match:class ^(steam)$"
      ]
      ++ map (title: {
        name = "silent-steam-popups";
        "match:class" = "^(steam)$";
        "match:title" = "^(${title})$";

        float = true;
        center = true;
        no_initial_focus = true;
      }) ["Sign in to Steam" "Launching..."];
  };
}
