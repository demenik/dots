{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./cli

    ./browsers/firefox
    ./qbittorrent.nix
    ./nautilus.nix

    ./nmgui.nix
    ./overskride.nix
    ./rofi.nix
    ./emulator.nix
    ./vpn.nix
    ./capture.nix

    ./spicetify.nix

    ./thunderbird.nix
    ./obsidian.nix
    ./office.nix
    ./anki.nix

    ./vesktop.nix

    ./wallpaper-engine.nix
  ];

  home.packages = with pkgs; [
    inputs.bettersoundcloud.packages.${pkgs.stdenv.hostPlatform.system}.default

    gimp
    aseprite

    rquickshare
    flameshot

    openvpn3

    libreoffice
  ];
}
