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
  ];

  home.packages = with pkgs; [
    tree
  ];
}
