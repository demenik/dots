{
  imports = [./conform.nix];

  programs.nixvim = {
    plugins.mini = {
      modules.align = {};
    };
  };
}
