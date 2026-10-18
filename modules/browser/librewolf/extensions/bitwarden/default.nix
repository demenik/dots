{firefoxAddons, ...}: {
  imports = [
    ./hyprland.nix
    ./theme.nix
  ];

  programs.librewolf.profiles.default.extensions.packages = [firefoxAddons.bitwarden];
}
