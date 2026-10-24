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
  in
    lib.mkIf (config.services.tailscale.enable && pluginUsers != []) {
      services.tailscale.extraSetFlags = ["--operator=${lib.head pluginUsers}"];

      systemd.services.tailscaled-set = {
        wantedBy = ["multi-user.target"];
        partOf = ["tailscaled.service"];
        serviceConfig.RemainAfterExit = true;
      };
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
