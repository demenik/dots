c: get-mode-color: [
  {
    path = 1;
    shorting_target = 150;
    color.fg = c.base04;
    __unkeyed-1 = "filename";
    disabled_buftypes = ["terminal"];
  }

  {
    sources = ["nvim_lsp"];
    __unkeyed-1 = "diagnostics";
    diagnostics_color = {
      color_error.fg = c.base08;
      color_warn.fg = c.base0A;
      color_info.fg = c.base0D;
      color_hint.fg = c.base0C;
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
      fg = c.base0E;
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
      added.fg = c.base0B;
      removed.fg = c.base08;
      modified.fg = c.base09;
    };
  }

  {
    # icon = ""; # NOTE: IDK why it shows twice
    icon = "";
    padding.right = 1;
    color.fg = c.base0E;
    __unkeyed-1 = "gh-actions";
  }

  {
    color.fg = c.base0F;
    __unkeyed-1 = "progress";
  }
]
