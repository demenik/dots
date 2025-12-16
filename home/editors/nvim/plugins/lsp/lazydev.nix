{pkgs, ...}: {
  programs.nixvim.plugins.lazydev = {
    enable = true;
    settings = {
      library = [
        {
          path = "${pkgs.vimPlugins.snacks-nvim}";
          words = ["Snacks"];
        }
      ];
    };
  };
}
