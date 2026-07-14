{pkgs, ...}: {
  programs.noctalia-shell = {
    plugins = {
      states."563115:network-manager-vpn" = {
        enabled = true;
        sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
      };
    };

    pluginSettings."563115:network-manager-vpn" = {
      displayMode = "alwaysHide";
      disconnectedColor = "none";
      connectedColor = "primary";
      disableToastNotifications = false;
    };

    wrapper.packages = with pkgs; [
      networkmanager
    ];
  };
}
