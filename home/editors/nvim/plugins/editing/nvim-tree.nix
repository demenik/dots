{
  programs.nixvim = {
    plugins = {
      nvim-tree = {
        enable = true;
        settings = {
          hijack_cursor = true;
          view.width = {
            min = 30;
            max = -1;
          };
          renderer = {
            group_empty = true;
            icons = {
              show.modified = true;
              glyphs.modified = "";
            };
            indent_markers.enable = true;
          };
          modified = {
            enable = true;
            show_on_dirs = false;
          };
          update_focused_file.enable = true;
        };
      };
    };
  };
}
