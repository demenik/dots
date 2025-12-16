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
}
