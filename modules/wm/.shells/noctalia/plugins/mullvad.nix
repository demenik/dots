{
  nixos = {
    services.mullvad-vpn.enable = true;
  };

  home = {
    programs.noctalia-shell = {
      plugins.states.mullvad = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };

      pluginSettings.mullvad = {
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
