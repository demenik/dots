{
  pkgs,
  lib,
  config,
  options,
  ...
}: let
  nixvimInstalled = options.programs ? nixvim && config.programs.nixvim.enable;
in {
  programs = lib.mkMerge [
    {
      tmux.plugins = with pkgs.tmuxPlugins; [
        vim-tmux-navigator
      ];
    }

    (lib.optionalAttrs nixvimInstalled {
      nixvim = {
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
    })
  ];
}
