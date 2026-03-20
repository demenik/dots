{
  imports = [
    ./hardware.nix
  ];

  system = "x86_64-linux";
  stateVersion = "25.05";
  hmStateVersion = "25.05";

  users = [../../users/demenik];
  modules = [
    ../default.nix
    ../../modules/system/boot/systemd-boot.nix
    ../../modules/greeter/greetd.nix
    ../../modules/system/fprint.nix

    ../../modules/system/eduroam.nix

    ../../modules/cli/git.nix
  ];

  moduleConfig = {
    git.signing = {
      pubKeyPath = "~/.ssh/id_ed25519.pub";
      pubKey = null;
    };
  };

  secrets = {
    eduroam.path = ../../secrets/eduroam.sops;
  };

  nixosConfig = {
    imports = [./battery.nix];

    networking.hostName = "thinkpad";
  };
}
