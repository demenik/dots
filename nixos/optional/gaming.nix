{pkgs, ...}: {
  programs.steam = {
    enable = true;

    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;

    extest.enable = true;
  };

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
