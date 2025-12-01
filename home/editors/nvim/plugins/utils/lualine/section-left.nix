colors: get-mode-color: [
  {
    __unkeyed-1 = "mode";
    color.__raw = get-mode-color;
  }

  {
    __unkeyed-1.__raw = ''
      function()
        local reg_rec = vim.fn.reg_recording()
        if reg_rec ~= "" then
          return "󰑊 rec (" .. reg_rec .. ")"
        else
          return ""
        end
      end
    '';
    color = {
      fg = colors.red;
      gui = "bold";
    };
  }

  {
    icon = "";
    __unkeyed-1 = "branch";
    color = {
      fg = colors.violet;
      gui = "bold";
    };
  }

  {
    mode = 2;
    __unkeyed-1 = "buffers";
    symbols = {
      modified = "";
      alternate_file = "";
    };
    buffers_color = {
      inactive.fg = colors.grey;
      active = {
        fg = colors.magenta;
        gui = "bold";
      };
    };
  }
]
