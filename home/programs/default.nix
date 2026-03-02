{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    ./cli

    ./browsers/librewolf
    ./qbittorrent.nix
    ./nautilus.nix

    ./nmgui.nix
    ./overskride.nix
    ./rofi.nix
    ./emulator.nix
    ./vpn.nix
    ./capture.nix
    ./librepods.nix

    ./spicetify.nix

    ./thunderbird.nix
    ./obsidian.nix
    ./office.nix
    ./anki.nix
    ./figma.nix
    ./vlc.nix

    ./vesktop.nix
    ./element.nix
    ./crypto.nix

    ./wallpaper-engine.nix
  ];

  home.packages = with pkgs; [
    inputs.bettersoundcloud.packages.${pkgs.stdenv.hostPlatform.system}.default

    gimp
    aseprite

    rquickshare

    openvpn3

    libreoffice
  ];
}
