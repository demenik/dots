{pkgs, ...}: {
  imports = [
    ./hardware.nix
    ./fans.nix
    ../../nixos/optional/gaming
  ];

  hardware.graphics.extraPackages = with pkgs; [
    rocmPackages.clr.icd
  ];
}
