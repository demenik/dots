{pkgs, ...}: {
  programs.noctalia-shell = {
    plugins = {
      states.network-manager-vpn = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
    };

    pluginSettings.network-manager-vpn = {
      displayMode = "alwaysHide";
      disconnectedColor = "none";
      connectedColor = "primary";
      disableToastNotifications = false;
    };
  };

  home.packages = with pkgs; [
    networkmanager
    networkmanagerapplet
  ];
}
