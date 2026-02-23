{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./fans.nix
    ../../optional/gaming
    ../../optional/i2p.nix
  ];

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
