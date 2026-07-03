{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.nixvim = {
    colorscheme = "catppuccin";

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = true;
        show_end_of_buffer = true;

        color_overrides = lib.optionalAttrs (config.theme.type == "template") {
          all.__raw = "(pcall(require, 'theme-colors') and require('theme-colors') or {})";
        };

        integrations = {
          cmp = true;
          gitsigns = true;
          mini.enable = true;
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

  theme.templates.nvim = {
    enable = true;
    target = "~/.config/nvim/lua/theme-colors.lua";
    post_hook =
      # bash
      ''
        for socket in /run/user/$(id -u)/nvim*.0; do
          [ -S "$socket" ] && ${pkgs.neovim}/bin/nvim --server "$socket" --remote-send "<C-\><C-N>:lua package.loaded['theme-colors'] = nil; local cp = require('catppuccin'); cp.options.color_overrides = cp.options.color_overrides or {}; cp.options.color_overrides.all = require('theme-colors'); cp.setup(); cp.compile(); vim.cmd('colorscheme catppuccin')<CR>" || true
        done
      '';
    text = ''
      return {
        rosewater = "{{colors.primary.default.hex | blend "#F5E0DC", 0.6 | set_saturation 80}}",
        flamingo = "{{colors.primary.default.hex | blend "#F2CDCD", 0.6 | set_saturation 80}}",
        pink = "{{colors.primary.default.hex | blend "#FFC0CB", 0.6 | set_saturation 80}}",
        mauve = "{{colors.tertiary.default.hex}}",
        red = "{{colors.error.default.hex}}",
        maroon = "{{colors.primary.default.hex | blend "#EBA0AC", 0.6 | set_saturation 80}}",
        peach = "{{colors.primary.default.hex | blend "#FFA500", 0.6 | set_saturation 80}}",
        yellow = "{{colors.primary.default.hex | blend "#FFFF00", 0.6 | set_saturation 80}}",
        green = "{{colors.primary.default.hex | blend "#00FF00", 0.6 | set_saturation 80}}",
        teal = "{{colors.primary.default.hex | blend "#008080", 0.6 | set_saturation 80}}",
        sky = "{{colors.primary.default.hex | blend "#87CEEB", 0.6 | set_saturation 80}}",
        sapphire = "{{colors.primary.default.hex | blend "#0F52BA", 0.6 | set_saturation 80}}",
        blue = "{{colors.primary.default.hex}}",
        lavender = "{{colors.primary.default.hex | blend "#E6E6FA", 0.6 | set_saturation 80}}",
        text = "{{colors.on_surface.default.hex}}",
        subtext1 = "{{colors.on_surface_variant.default.hex}}",
        subtext0 = "{{colors.on_surface_variant.default.hex}}",
        overlay2 = "{{colors.outline.default.hex}}",
        overlay1 = "{{colors.outline_variant.default.hex}}",
        overlay0 = "{{colors.outline_variant.default.hex}}",
        surface2 = "{{colors.surface_container_highest.default.hex}}",
        surface1 = "{{colors.surface_container_high.default.hex}}",
        surface0 = "{{colors.surface_container.default.hex}}",
        base = "{{colors.surface.default.hex}}",
        mantle = "{{colors.surface_container_low.default.hex}}",
        crust = "{{colors.surface_container_lowest.default.hex}}",
      }
    '';
  };
}
