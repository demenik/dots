{
  plugins = {
    nvim-autopairs = {
      enable = true;
      settings = {
        mapBs = false;
        checkTs = true;
        tsConfig = {
          lua = ["string" "source"];
          javascript = ["string" "template_string"];
        };
        disabledFiletypes = ["minifiles"];
      };
    };

    mini = {
      modules = {
        move = {};
        splitjoin = {};
        # surround = {};
        trailspace = {};
      };
    };

    rainbow-delimiters.enable = true;

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
}
