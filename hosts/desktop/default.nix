{
  imports = [
    ../full.nix

    ./hardware.nix
    ./audio.nix
  ];

  system = "x86_64-linux";
  stateVersion = "25.11";
  hmStateVersion = "25.11";

  users = [../../users/demenik];
  modules = [
    ../default.nix
    ../../modules/system/lanzaboote.nix
    ../../modules/greeter/greetd.nix
  ];

  nixosConfig = {
    networking.hostName = "desktop";
  };
}
