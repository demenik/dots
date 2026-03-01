{pkgs, ...}: {
  imports = [
    ./zoxide.nix
    ./bat.nix
    ./eza.nix
    ./btop.nix
    ./ssh.nix
    ./fastfetch.nix
    ./jq.nix
    ./ai.nix
    ./debugging.nix
    ./ncdu.nix
    ./nh.nix
    ./rg.nix
    ./fd.nix
    ./gh.nix
    ./spotify-player.nix
  ];

  home.packages = with pkgs; [
    tree
    zip
    unzip
  ];
}
