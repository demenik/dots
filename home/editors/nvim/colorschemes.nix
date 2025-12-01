{
  programs.nixvim = {
    colorscheme = "catppuccin";

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = true;
        integrations = {
          cmp = true;
          gitsigns = true;
          mini = {
            enable = true;
            indentscope_color = "lavender";
          };
          nvimtree = true;
          treesitter = true;
          alpha = true;
          fzf = true;
          grug_far = true;
          harpoon = true;
          markdown = true;
          noice = true;
          copilot_vim = true;
          lsp_trouble = true;
          which_key = true;
        };
      };
    };
  };
}
