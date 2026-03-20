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

    {
      key = "<leader>w";
      options.desc = "Write buffer";
      action = "<cmd>w!<cr>";
    }
    {
      key = "<leader>n";
      options.desc = "New buffer";
      action = "<cmd>ene | startinsert<cr>";
    }
    {
      key = "<leader>Q";
      options.desc = "Quit all";
      action = "<cmd>qa<cr>";
    }
    {
      key = "<leader>q";
      options.desc = "Quit window";
      action = "<cmd>quit<cr>";
    }
    {
      key = "<leader>u";
      options.desc = "Undo Tree";
      action = "<cmd>UndotreeToggle<cr>";
    }
  ]
  ++ map window-jump ["h" "j" "k" "l"]
