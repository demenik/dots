{lib, ...}: {
  imports = [
    ./screentoolkit.nix
  ];

  moduleOptions = with lib; {
    programs.noctalia.plugins = {
      privacy-indicator.micFilterRegexes = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "List of regexes for audio input sources to filter out from the privacy indicator";
      };
    };
  };

  home = {config, ...}: {
    imports = [
      ./vpn.nix
      ./tailscale.nix
    ];

    programs.noctalia-shell = {
      plugins = {
        autoUpdate = true;
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
      };

      pluginSettings = {
        privacy-indicator = {
          hideInactive = true;
          enableToast = false;

          activeColor = "primary";
          inactiveColor = "none";

          iconSpacing = 2;
          removeMargins = false;

          micFilterRegex =
            builtins.concatStringsSep "|"
            config.programs.noctalia.plugins.privacy-indicator.micFilterRegexes;
        };
      };
    };
  };
}
