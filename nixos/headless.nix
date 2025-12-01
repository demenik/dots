{
  pkgs,
  stateVersion,
  user,
  ...
}: {
  imports = [
    ./global
    ./users/demenik.nix

    ./optional/docker.nix
    ./optional/direnv.nix
  ];

  programs.zsh.enable = true;
  users.users.${user}.shell = pkgs.zsh;

  system = {inherit stateVersion;};
}
