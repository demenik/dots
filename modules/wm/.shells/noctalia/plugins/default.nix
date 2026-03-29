{
  imports = [
    ./screenshot.nix
  ];

  home = {
    imports = [
      ./vpn.nix
    ];

    programs.noctalia-shell = {
      plugins = {
        autoUpdate = false;
        notifyUpdates = true;

        sources = [
          {
            enabled = true;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
        ];

        states = {
          privacy-indicator = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
          polkit-agent = {
            enabled = true;
            sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
          };
        };

        pluginSettings = {
          privacy-indicator = {
            hideInactive = true;
            enableToast = false;

            activeColor = "primary";
            inactiveColor = "none";

            iconSpacing = 2;
            removeMargins = false;

            micFilterRegex = "";
          };
        };
      };
    };
  };
}
