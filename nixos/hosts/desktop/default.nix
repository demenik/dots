{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./fans.nix
    ../../optional/gaming
  ];

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
