{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./battery.nix
  ];

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
