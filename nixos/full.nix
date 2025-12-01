{
  pkgs,
  stateVersion,
  user,
  ...
}: {
  imports = [
    ./global
    ./users/demenik.nix

    ./optional/backup.nix
    ./optional/greetd.nix
    ./optional/networkmanager.nix
    ./optional/bluetooth.nix
    ./optional/fprint.nix
    ./optional/vm.nix
    ./optional/gaming.nix
    ./optional/adb.nix
    ./optional/docker.nix
    ./optional/direnv.nix
    ./optional/wireshark.nix
  ];

  programs.zsh.enable = true;
  users.users.${user}.shell = pkgs.zsh;

  boot = {
    loader.efi.canTouchEfiVariables = true;
    kernelPackages = pkgs.linuxPackages_latest;
  };

  programs.hyprland.enable = true;
  services.displayManager.defaultSession = "hyprland";

  system = {inherit stateVersion;};
}
