{
  name = "osu";

  modules = [../default.nix];

  nixos = {
    hardware.opentabletdriver = {
      enable = true;
      daemon.enable = false;
    };
  };
  hostInstructions = ''
    Install opentabletdriver
  '';

  home = {pkgs, ...}: {
    home.packages = [pkgs.osu-lazer-bin];
  };
}
