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

    ../../modules/system/eduroam.nix
  ];

  secrets = {
    eduroam.path = ../../secrets/eduroam.sops;
  };

  nixosConfig = {
    imports = [./battery.nix];

    networking.hostName = "thinkpad";
  };
}
