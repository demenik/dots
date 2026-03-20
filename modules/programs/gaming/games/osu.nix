{
  name = "osu";

  modules = [../default.nix];

  home = {pkgs, ...}: {
    home.packages = [pkgs.osu-lazer-bin];
  };
}
