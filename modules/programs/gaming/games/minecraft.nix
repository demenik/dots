{
  name = "minecraft";

  modules = [../default.nix];

  home = {pkgs, ...}: {
    home.packages = [pkgs.prismlauncher];
  };
}
