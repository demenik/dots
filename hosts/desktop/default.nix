{
  system = "x86_64-linux";
  stateVersion = "25.11";
  hmStateVersion = "25.11";

  users = [../../users/demenik];
  modules = [
    ../../modules/lanzaboote.nix
  ];

  nixosConfig = {
    imports = [
      ./hardware.nix
    ];

    networking.hostName = "desktop";
  };
}
