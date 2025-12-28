{pkgs, ...}: {
  imports = [
    ./steam.nix
    ./mangohud.nix
  ];

  environment.systemPackages = with pkgs; [
    lutris
  ];
}
