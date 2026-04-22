{
  imports = [
    ../full.nix
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
      pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIE+jwmNk9ciSlN/hEKXYGPLBE7lma1tqevXje0EKqqlp demenik@thinkpad";
    };
  };

  secrets = {
    eduroam.path = ../eduroam.sops.yaml;
  };

  nixosConfig = {
    imports = [./battery.nix];

    networking.hostName = "thinkpad";
  };
}
