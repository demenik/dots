{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./mangohud.nix
    ./hyprland.nix
  ];

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
