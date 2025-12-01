{
  extraConfigLua = builtins.readFile ./hide_statusbar.lua;

  plugins.lualine = let
    colors = import ./colors.nix;
  in {
    enable = true;
    settings = {
      options = {
        section_separators = "";
        component_separators = "";
        theme = {
          normal.c = {
            bg = "";
            inherit (colors) fg;
          };
          inactive.c = {
            bg = "";
            inherit (colors) fg;
          };
        };

        refresh.events = [
          "WinEnter"
          "BufEnter"
          "BufWritePost"
          "SessionLoadPost"
          "FileChangedShellPost"
          "VimResized"
          "Filetype"
          "CursorMoved"
          "CursorMovedI"
          "ModeChanged"
          "RecordingEnter"
          "RecordingLeave"
        ];
      };

      # to be visible, change laststatus option value at options.nix
      sections = {
        # these are to remove the defaults
        lualine_a = [{}];
        lualine_b = [{}];
        lualine_c = [{}];
        lualine_x = [{}];
        lualine_y = [{}];
        lualine_z = [{}];
      };

      inactive_sections = {
        # these are to remove the defaults
        lualine_a = [{}];
        lualine_b = [{}];
        lualine_c = [{}];
        lualine_x = [{}];
        lualine_y = [{}];
        lualine_z = [{}];
      };

      tabline = import ./tabline.nix;
    };
  };

  keymaps = let
    buffers = bind: let
      num =
        if (bind == 0)
        then 10
        else bind;
    in {
      key = "<M-${toString bind}>";
      mode = ["n" "i" "v" "s" "t" "o"];
      options.desc = "Buffer ${toString num}";
      action = "<cmd>LualineBuffersJump ${toString num}<cr>";
    };
  in
    map buffers [1 2 3 4 5 6 7 8 9 10];
}
