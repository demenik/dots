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
        renderer = {
          group_empty = true;
        };
      };
    };
  };
}
