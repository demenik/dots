{
  programs.nixvim = {
    plugins.toggleterm = {
      enable = true;
      settings = {
        persistent_size = true;
        direction = "horizontal";
        open_mapping = "[[<M-CR>]]";

        highlights = {
          Normal.link = "NormalFloat";
          WinSeparator.link = "FloatBorder";
        };
      };
    };
  };
}
