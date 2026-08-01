{pkgs, ...}: {
  imports = [
    ./commands.nix
    ./nix
    ./text
  ];

  programs.nixvim = {
    imports = [./options.nix];

    plugins.luasnip = {
      enable = true;
      settings = {
        enable_autosnippets = true;
        store_selection_keys = "<Tab>";
      };
      fromVscode = [
        {
          lazyLoad = true;
          paths = pkgs.vimPlugins.friendly-snippets;
        }
      ];
    };
  };
}
