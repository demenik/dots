{pkgs, ...}: {
  programs.tmux.plugins = with pkgs.tmuxPlugins; [
    vim-tmux-navigator
  ];

  programs.nixvim = {
    extraPlugins = with pkgs.vimPlugins; [
      vim-tmux-navigator
    ];

    keymaps = [
      {
        key = "<C-h>";
        action = "<cmd><C-U>TmuxNavigateLeft<cr>";
      }
      {
        key = "<C-j>";
        action = "<cmd><C-U>TmuxNavigateDown<cr>";
      }
      {
        key = "<C-k>";
        action = "<cmd><C-U>TmuxNavigateUp<cr>";
      }
      {
        key = "<C-l>";
        action = "<cmd><C-U>TmuxNavigateRight<cr>";
      }
      {
        key = "<C-\\>";
        action = "<cmd><C-U>TmuxNavigatePrevious<cr>";
      }
    ];
  };
}
