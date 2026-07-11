{
  modules = [
    ../modules/system/wine.nix
    ../modules/system/bluetooth.nix

    ../modules/programs/networkmanager.nix

    ../modules/services/tor.nix
    ../modules/services/i2p.nix
  ];

  nixosConfig = {
    services.fwupd.enable = true;
  };

  secrets = {
    "uni-ulm-vpn/uni-ulm-vpn".path = ./secrets/uni-ulm-vpn.sops.yaml;
    "homelab-vpn/homelab-vpn".path = ./secrets/homelab-vpn.sops.yaml;
  };
}
