{
  nixos = {
    services.mullvad-vpn.enable = true;
  };

  home = {
    programs.noctalia-shell = {
      plugins.states."563115:mullvad" = {
        enabled = true;
        sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
      };

      pluginSettings."563115:mullvad" = {
        favoriteCountries = [
          "de"
          "us"
          "nl"
          "ch"
          "gb"
          "se"
        ];

        refreshInterval = 3000;
        expiryWarningDays = 7;

        compactMode = true;
        showCountryFlag = true;
        showCityName = false;
        showIp = false;

        clickAction = "panel";
        relayClickConnects = true;
        confirmDisconnectInLockdown = true;
      };
    };
  };
}
