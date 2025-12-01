let
  toggle = key: action: {
    key = "\\${key}";
    options.desc = "Toggle ${action}";
    action = "<cmd>setlocal ${action}!<cr>";
  };
  window-jump = key: {
    key = "<c-${key}>";
    action = "<c-w>${key}";
  };
in
  [
    {
      key = "<S-u>";
      options.desc = "Redo";
      action = "<C-r>";
    }

    {
      key = "<c-c>";
      options.desc = "Comment line";
      action = "<cmd>normal gcc<cr>";
    }

    (toggle "w" "wrap")
    (toggle "n" "number")
    (toggle "r" "relativenumber")
    (toggle "i" "ignorecase")
    (toggle "c" "cursorline")
    (toggle "C" "cursorcolumn")

    {
      key = "<s-h>";
      options.desc = "Previous buffer";
      action = "<cmd>bprevious<cr>";
    }
    {
      key = "<s-l>";
      options.desc = "Next Buffer";
      action = "<cmd>bnext<cr>";
    }
  ]
  ++ map window-jump ["h" "j" "k" "l"]
