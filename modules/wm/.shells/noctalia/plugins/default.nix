{lib, ...}: {
  imports = [
    ./screentoolkit.nix
    ./mullvad.nix
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
            enabled = false;
            name = "Official Noctalia Plugins";
            url = "https://github.com/noctalia-dev/noctalia-plugins";
          }
          {
            enabled = true;
            name = "demenik's Noctalia Plugins";
            url = "https://github.com/demenik/noctalia-v4-plugins";
          }
        ];

        states = {
          "563115:privacy-indicator" = {
            enabled = true;
            sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
          };
          "563115:polkit-agent" = {
            enabled = true;
            sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
          };
          "563115:obsidian-provider" = {
            enabled = true;
            sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
          };
        };
      };

      pluginSettings = {
        "563115:privacy-indicator" = {
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
