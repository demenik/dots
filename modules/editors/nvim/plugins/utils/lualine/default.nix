{
  programs.nixvim = {
    # Hide bottom bar
    opts = {
      laststatus = 0;
      cmdheight = 0;
      showtabline = 2;
    };
    autoCmd = [
      {
        event = ["BufEnter"];
        callback.__raw = ''
          function()
            vim.opt.laststatus = 0
          end
        '';
      }
    ];

    plugins.lualine = let
      c = {
        base00.__raw = "require('catppuccin.palettes').get_palette().base";
        base01.__raw = "require('catppuccin.palettes').get_palette().mantle";
        base02.__raw = "require('catppuccin.palettes').get_palette().surface0";
        base03.__raw = "require('catppuccin.palettes').get_palette().surface1";
        base04.__raw = "require('catppuccin.palettes').get_palette().surface2";
        base05.__raw = "require('catppuccin.palettes').get_palette().text";
        base06.__raw = "require('catppuccin.palettes').get_palette().rosewater";
        base07.__raw = "require('catppuccin.palettes').get_palette().rosewater";
        base08.__raw = "require('catppuccin.palettes').get_palette().red";
        base09.__raw = "require('catppuccin.palettes').get_palette().peach";
        base0A.__raw = "require('catppuccin.palettes').get_palette().yellow";
        base0B.__raw = "require('catppuccin.palettes').get_palette().green";
        base0C.__raw = "require('catppuccin.palettes').get_palette().teal";
        base0D.__raw = "require('catppuccin.palettes').get_palette().blue";
        base0E.__raw = "require('catppuccin.palettes').get_palette().mauve";
        base0F.__raw = "require('catppuccin.palettes').get_palette().flamingo";
      };
    in {
      enable = true;
      settings = {
        options = {
          section_separators = "";
          component_separators = "";
          theme = {
            normal.c = {
              bg = "";
              fg = c.base05;
            };
            inactive.c = {
              bg = "";
              fg = c.base05;
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

        tabline = import ./tabline.nix c;
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
  };
}
