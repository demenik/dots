{
  name = "minecraft";

  modules = [../default.nix];

  home = {
    pkgs,
    config,
    ...
  }: {
    home.packages = [
      (config.programs.gaming.wrapper.exposeOnPath pkgs.prismlauncher)
    ];
  };
}
