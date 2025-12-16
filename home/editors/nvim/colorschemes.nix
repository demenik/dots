{
  programs.nixvim = {
    colorscheme = "catppuccin";

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = true;
        show_end_of_buffer = true;
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
          neotest = true;
          dap = true;
          snacks.enable = true;
        };
        custom_highlights =
          # lua
          ''
            function(colors)
              return {
                Pmenu = { bg = colors.mantle, fg = colors.text },
                PmenuSel = { bg = colors.surface1, fg = "NONE", style = { "bold" } },

                CmpItemKindFunction = { bg = colors.blue, fg = colors.crust },
                CmpItemKindMethod = { bg = colors.blue, fg = colors.crust },
                CmpItemKindConstructor = { bg = colors.blue, fg = colors.crust },

                CmpItemKindClass = { bg = colors.yellow, fg = colors.crust },
                CmpItemKindInterface = { bg = colors.yellow, fg = colors.crust },
                CmpItemKindStruct = { bg = colors.yellow, fg = colors.crust },
                CmpItemKindModule = { bg = colors.yellow, fg = colors.crust },
                CmpItemKindTypeParameter = { bg = colors.yellow, fg = colors.crust },

                CmpItemKindField = { bg = colors.teal, fg = colors.crust },
                CmpItemKindProperty = { bg = colors.teal, fg = colors.crust },
                CmpItemKindEnumMember = { bg = colors.teal, fg = colors.crust },

                CmpItemKindVariable = { bg = colors.sky, fg = colors.crust },
                CmpItemKindValue = { bg = colors.sky, fg = colors.crust },
                CmpItemKindReference = { bg = colors.sky, fg = colors.crust },

                CmpItemKindSnippet = { bg = colors.mauve, fg = colors.crust },
                CmpItemKindKeyword = { bg = colors.mauve, fg = colors.crust },

                CmpItemKindConstant = { bg = colors.peach, fg = colors.crust },
                CmpItemKindEnum = { bg = colors.peach, fg = colors.crust },

                CmpItemKindText = { bg = colors.lavender, fg = colors.crust },
                CmpItemKindFile = { bg = colors.lavender, fg = colors.crust },
                CmpItemKindFolder = { bg = colors.lavender, fg = colors.crust },

                CmpItemKindEvent = { bg = colors.red, fg = colors.crust },
                CmpItemKindUnit = { bg = colors.red, fg = colors.crust },
              }
            end
          '';
      };
    };
  };
}
