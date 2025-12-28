{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./cli

    ./browsers/firefox.nix
    ./qbittorrent.nix

    ./nmgui.nix
    ./overskride.nix
    ./rofi.nix
    ./emulator.nix
    ./vpn.nix

    ./spicetify.nix

    ./thunderbird.nix
    ./obsidian.nix
    ./office.nix

    ./vesktop.nix
  ];

  home.packages = with pkgs; [
    inputs.bettersoundcloud.packages.${pkgs.stdenv.hostPlatform.system}.default

    gimp
    aseprite

    nautilus
    nautilus-open-any-terminal
    rquickshare
    flameshot

    openvpn3

    libreoffice

    prismlauncher
  ];
}
