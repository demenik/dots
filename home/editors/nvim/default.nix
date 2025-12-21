{inputs, ...}: {
  imports = [
    inputs.nixvim.homeModules.nixvim
    ./plugins
    ./colorschemes.nix
  ];

  programs.nixvim = {
    enable = true;
    defaultEditor = true;

    globals.mapleader = " ";
    clipboard.register = "unnamedplus";
    luaLoader.enable = true;

    opts = import ./options.nix;
    keymaps = import ./keymaps.nix;

    extraConfigLua =
      # lua
      ''
        -- Disable netrw
        g.loaded_netrw = 1
        g.loaded_netrwPlugin = 1

        -- Hide line numbers in terminal mode
        vim.cmd [[ autocmd TermOpen * setlocal nonumber norelativenumber ]]

        -- Disable arrow keys
        -- vim.cmd [[ :map <Up> <Nop> ]]
        -- vim.cmd [[ :map <Left> <Nop> ]]
        -- vim.cmd [[ :map <Right> <Nop> ]]
        -- vim.cmd [[ :map <Down> <Nop> ]]

        -- Add filetypes
        vim.filetype.add {
          pattern = {
            [".*%.arb"] = "json",
            ["%.sqruff"] = "toml",
          },
        }

        -- Set up OSC 52
        if os.getenv "SSH_TTY" or os.getenv "SSH_CONNECTION" then
          local osc52 = require "vim.ui.clipboard.osc52"
          vim.g.clipboard = {
            name = "OSC 52",
            copy = {
              ["+"] = osc52.copy "+",
              ["*"] = osc52.copy "*",
            },
            paste = {
              ["+"] = osc52.paste "+",
              ["*"] = osc52.paste "*",
            },
          }
        end
      '';
  };
}
