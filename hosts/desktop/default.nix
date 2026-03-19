{
  imports = [
    ./hardware.nix
  ];

  system = "x86_64-linux";
  stateVersion = "25.11";
  hmStateVersion = "25.11";

  users = [../../users/demenik];
  modules = [
    ../../modules/lanzaboote.nix
  ];

  nixosConfig = {
    networking.hostName = "desktop";
  };
}
