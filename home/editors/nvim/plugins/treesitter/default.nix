{pkgs, ...}: {
  plugins = {
    treesitter = {
      enable = true;
      folding.enable = false;
      nixGrammars = true;
      nixvimInjections = true;
      settings = (import ./settings.nix) pkgs;
    };

    ts-autotag.enable = true;
    treesitter-textobjects = import ./textobjects.nix;
  };
}
