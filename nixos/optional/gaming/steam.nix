{
  user,
  pkgs,
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

    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  home-manager.users.${user} = {
    wayland.windowManager.hyprland.settings.windowrulev2 =
      map (rule: "${rule}, class:^(steam)$, title:^(Sign in to Steam)$") [
        "float"
        "center"
      ]
      ++ map (rule: "${rule}, class:^(steam)$, title:^(Launching...)$") [
        "float"
        "center"
        "workspace 1"
        "pin"
      ];
  };
}
