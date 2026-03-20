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

    ../../modules/cli/git.nix
  ];

  moduleConfig = {
    git.signing = {
      pubKeyPath = "~/.ssh/id_ed25519.pub";
      pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvLK5Of4imQHlPAd+2wQaKf7bTMv34RmEG2TuLvZ966 demenik@desktop";
    };
  };

  nixosConfig = {
    networking.hostName = "desktop";
  };
}
