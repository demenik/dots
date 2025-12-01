{
  plugins.toggleterm = {
    enable = true;
    settings = {
      float_opts = {};
      persistent_size = true;
      direction = "horizontal";
      open_mapping = "[[<M-CR>]]";
      shade_filetypes = ["lazygit"];

      highlights.FloatBorder.guifg = "#7b8496";
    };
  };
}
