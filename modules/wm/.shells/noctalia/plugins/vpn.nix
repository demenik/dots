{pkgs, ...}: {
  programs.noctalia-shell = {
    plugins = {
      states.network-manager-vpn = {
        enabled = true;
        sourceUrl = "https://github.com/noctalia-dev/noctalia-plugins";
      };
    };
  };

  home.packages = with pkgs; [
    networkmanager
    networkmanagerapplet
  ];
}
