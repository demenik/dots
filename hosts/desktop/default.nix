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
    ../../modules/system/boot/lanzaboote.nix
    ../../modules/greeter/greetd.nix

    ../../modules/programs/gaming/steam.nix
  ];

  nixosConfig = {
    networking.hostName = "desktop";
  };
}
