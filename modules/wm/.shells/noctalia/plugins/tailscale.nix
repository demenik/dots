{
  nixos = {
    lib,
    config,
    ...
  }: let
    # Tailscale supports a single operator, pick first user running the plugin
    pluginUsers =
      lib.filter
      (user: config.home-manager.users.${user}.programs.noctalia-shell.plugins.states."563115:tailscale".enabled or false)
      config.flake-modules.users;
  in {
    services.tailscale.extraSetFlags =
      lib.mkIf (config.services.tailscale.enable && pluginUsers != [])
      ["--operator=${lib.head pluginUsers}"];
  };

  home = {config, ...}: {
    programs.noctalia-shell = {
      plugins.states."563115:tailscale" = {
        enabled = true;
        sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
      };

      pluginSettings."563115:tailscale" = {
        compactMode = true;
        showIpAddress = false;
        showPeerCount = false;
        hideDisconnected = false;
        hideMullvadExitNodes = false;
        showSearchBar = false;

        refreshInterval = 5000;
        pingCount = 5;
        defaultPeerAction = "copy-ip";
        terminalCommand = config.terminal.command or "";

        taildropEnabled = true;
        taildropDownloadDir = "~/Downloads";
        taildropReceiveMode = "operator";
      };
    };
  };
}
