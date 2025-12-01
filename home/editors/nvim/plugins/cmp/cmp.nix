{lib, ...}: {
  plugins = {
    cmp = {
      enable = true;
      autoEnableSources = true;
      settings = {
        experimental.ghost_text = true;
        mapping.__raw = ''
          cmp.mapping.preset.insert({
            ["<C-j>"] = cmp.mapping.scroll_docs(4),
            ["<C-k>"] = cmp.mapping.scroll_docs(-4),
            ["<CR>"] = cmp.mapping.confirm({
              behavior = cmp.ConfirmBehavior.Replace,
              select = true
            }),
            ["<Tab>"] = cmp.mapping(function(fallback)
              local luasnip = require("luasnip")

              if cmp.visible() then
                cmp.select_next_item()
              elseif luasnip.locally_jumpable(1) then
                luasnip.jump(1)
              else
                fallback()
              end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
              local luasnip = require("luasnip")

              if cmp.visible() then
                cmp.select_prev_item()
              elseif luasnip.locally_jumpable(-1) then
                luasnip.jump(-1)
              else
                fallback()
              end
            end, { "i", "s" }),
          })
        '';

        window = {
          completion = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
            col_offset = -3;
            side_padding = 0;
          };
          documentation = {
            winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None";
            col_offset = -3;
            side_padding = 0;
          };
        };

        snippet.expand =
          # lua
          ''
            function(args)
              require'luasnip'.lsp_expand(args.body)
            end
          '';

        formatting = {
          # expandable_indicator = true;
          fields = ["kind" "abbr" "menu"];

          format =
            lib.mkForce
            # lua
            ''
              function(entry, vim_item)
                local kind = require("lspkind").cmp_format({ mode = "symbol_text", maxwidth = 50 })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. (strings[1] or "") .. " "
                kind.menu = "    (" .. (strings[2] or "") .. ")"
                return kind
              end
            '';
        };

        completion.completeopt = "menu,menuone,preview,noinsert";

        sources = [
          {name = "nvim_lsp";}
          {name = "buffer";}
          {name = "path";}
          {name = "luasnip";}
        ];
      };

      cmdline = {
        "/" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [{name = "buffer";}];
        };
        ":" = {
          mapping.__raw = "cmp.mapping.preset.cmdline()";
          sources = [
            {
              name = "path";
            }
            {
              name = "cmdline";
              option.ignore_cmds = ["Man" "!"];
            }
          ];
        };
      };
    };

    cmp-nvim-lsp.enable = true;
    cmp-buffer.enable = true;
    cmp-path.enable = true;
    cmp-cmdline.enable = true;
    cmp_luasnip.enable = true;
  };

  # TODO: fix (https://github.com/hrsh7th/nvim-cmp/wiki/Menu-Appearance#how-to-get-types-on-the-left-and-offset-the-menu)
  highlight = {
    PmenuSel = {
      bg = "#282C34";
      fg = "NONE";
    };
    Pmenu = {
      fg = "#C5CDD9";
      bg = "#22252A";
    };

    CmpItemAbbrDeprecated = {
      fg = "#7E8294";
      bg = "NONE";
      strikethrough = true;
    };
    CmpItemAbbrMatch = {
      fg = "#82AAFF";
      bg = "NONE";
      bold = true;
    };
    CmpItemAbbrMatchFuzzy = {
      fg = "#82AAFF";
      bg = "NONE";
      bold = true;
    };
    CmpItemMenu = {
      fg = "#C792EA";
      bg = "NONE";
      italic = true;
    };

    CmpItemKindField = {
      fg = "#EED8DA";
      bg = "#B5585F";
    };
    CmpItemKindProperty = {
      fg = "#EED8DA";
      bg = "#B5585F";
    };
    CmpItemKindEvent = {
      fg = "#EED8DA";
      bg = "#B5585F";
    };

    CmpItemKindText = {
      fg = "#C3E88D";
      bg = "#9FBD73";
    };
    CmpItemKindEnum = {
      fg = "#C3E88D";
      bg = "#9FBD73";
    };
    CmpItemKindKeyword = {
      fg = "#C3E88D";
      bg = "#9FBD73";
    };

    CmpItemKindConstant = {
      fg = "#FFE082";
      bg = "#D4BB6C";
    };
    CmpItemKindConstructor = {
      fg = "#FFE082";
      bg = "#D4BB6C";
    };
    CmpItemKindReference = {
      fg = "#FFE082";
      bg = "#D4BB6C";
    };

    CmpItemKindFunction = {
      fg = "#EADFF0";
      bg = "#A377BF";
    };
    CmpItemKindStruct = {
      fg = "#EADFF0";
      bg = "#A377BF";
    };
    CmpItemKindClass = {
      fg = "#EADFF0";
      bg = "#A377BF";
    };
    CmpItemKindModule = {
      fg = "#EADFF0";
      bg = "#A377BF";
    };
    CmpItemKindOperator = {
      fg = "#EADFF0";
      bg = "#A377BF";
    };

    CmpItemKindVariable = {
      fg = "#C5CDD9";
      bg = "#7E8294";
    };
    CmpItemKindFile = {
      fg = "#C5CDD9";
      bg = "#7E8294";
    };

    CmpItemKindUnit = {
      fg = "#F5EBD9";
      bg = "#D4A959";
    };
    CmpItemKindSnippet = {
      fg = "#F5EBD9";
      bg = "#D4A959";
    };
    CmpItemKindFolder = {
      fg = "#F5EBD9";
      bg = "#D4A959";
    };

    CmpItemKindMethod = {
      fg = "#DDE5F5";
      bg = "#6C8ED4";
    };
    CmpItemKindValue = {
      fg = "#DDE5F5";
      bg = "#6C8ED4";
    };
    CmpItemKindEnumMember = {
      fg = "#DDE5F5";
      bg = "#6C8ED4";
    };

    CmpItemKindInterface = {
      fg = "#D8EEEB";
      bg = "#58B5A8";
    };
    CmpItemKindColor = {
      fg = "#D8EEEB";
      bg = "#58B5A8";
    };
    CmpItemKindTypeParameter = {
      fg = "#D8EEEB";
      bg = "#58B5A8";
    };
  };
}
