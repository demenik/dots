colors: get-mode-color: [
  {
    path = 1;
    shorting_target = 150;
    color.fg = colors.grey;
    __unkeyed-1 = "filename";
    disabled_buftypes = ["terminal"];
  }

  {
    sources = ["nvim_lsp"];
    __unkeyed-1 = "diagnostics";
    diagnostics_color = {
      color_error.fg = colors.red;
      color_warn.fg = colors.yellow;
      color_info.fg = colors.blue;
      color_hint.fg = colors.cyan;
    };
    symbols = {
      error = " ";
      warn = " ";
      info = " ";
    };
  }
  {
    __unkeyed-1 = "lsp_status";
    icon = "lsp:";
    disabled_buftypes = ["terminal"];
    color = {
      fg = colors.magenta;
      gui = "bold";
    };
    ignore_lsp = [
      "typos_lsp"
    ];
  }

  {
    __unkeyed-1 = "diff";
    symbols = {
      added = " ";
      modified = "󰝤 ";
      removed = " ";
    };
    diff_color = {
      added.fg = colors.green;
      removed.fg = colors.red;
      modified.fg = colors.orange;
    };
  }

  {
    # icon = ""; # NOTE: IDK why it shows twice
    icon = "";
    padding.right = 1;
    color.fg = colors.violet;
    __unkeyed-1 = "gh-actions";
  }

  {
    color.fg = colors.pink;
    __unkeyed-1 = "progress";
  }
]
