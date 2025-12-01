{
  plugins = {
    fugitive.enable = true;
    diffview.enable = true;
    gitmessenger = {
      enable = true;
      settings = {
        include_diff = "current";
        no_default_mappings = true;
      };
    };
    gitsigns = import ./gitsigns.nix;
  };
}
