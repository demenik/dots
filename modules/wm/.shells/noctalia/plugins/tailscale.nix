{config, ...}: {
  programs.noctalia-shell = {
    plugins.states.tailscale = {
      enabled = true;
      sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
    };

    pluginSettings.tailscale = {
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
}
