{
  user,
  pkgs,
  stateVersion,
  lib,
  ...
}: {
  imports = [
    ./git.nix
  ];

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs.home-manager.enable = true;

  home = {
    inherit stateVersion;
    username = lib.mkDefault user;
    homeDirectory = lib.mkDefault "/home/${user}";
    sessionPath = ["$HOME/.local/bin"];
  };
}
