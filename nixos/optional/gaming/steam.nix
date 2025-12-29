{user, ...}: {
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extest.enable = true;
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
