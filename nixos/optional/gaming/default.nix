{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./mangohud.nix
    ./hyprland.nix
    ./controller.nix
  ];

  environment.systemPackages = with pkgs; [
    lutris
  ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
}
