{
  imports = [
    ./servers.nix
    ./lint.nix
    ./otter.nix
    ./lazydev.nix
  ];

  programs.nixvim = {
    plugins = {
      lspkind = import ./lspkind.nix;
      lspconfig.enable = true;
      trouble.enable = true;
      tiny-inline-diagnostic = {
        enable = true;
        settings.options.multilines.enabled = true;
      };
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>l";
        group = "Lsp";
        icon = {
          icon = " ";
          color = "orange";
        };
      }
      {
        __unkeyed-1 = "<leader>x";
        group = "Trouble";
        icon = {
          icon = "󱖫 ";
          color = "green";
        };
      }
    ];
    keymaps = let
      trouble-lsp = key: action: {
        mode = "";
        inherit key;
        options.desc = action;
        action = "<cmd>Trouble lsp_${action}<cr>";
      };
      lsp = key: action: desc: {
        key = "<leader>l${key}";
        action = "<cmd>${action}<cr>";
        options.desc = desc;
      };
      trouble = key: action: desc: {
        key = "<leader>x${key}";
        action = "<cmd>Trouble ${action} focus=true win.position=bottom<cr>";
        options.desc = desc;
      };
    in [
      (trouble-lsp "gd" "definitions")
      (trouble-lsp "gr" "references")
      (trouble-lsp "gi" "implementations")

      # LSP
      (lsp "i" "checkhealth vim.lsp" "Info")
      (lsp "R" "lsp restart" "Restart")
      (lsp "s" "lsp start" "Start")
      (lsp "x" "lsp stop" "Stop")
      {
        mode = ["n" "v"];
        key = "<leader>lf";
        action.__raw = ''
          function()
            require("conform").format {
              lsp_fallback = true,
              timeout_ms = 2000,
            }
          end
        '';
        options.desc = "Format Buffer";
      }
      {
        key = "<leader>lF";
        action = "<cmd>ConformInfo<cr>";
        options.desc = "Conform Info";
      }
      {
        key = "<leader>lr";
        action.__raw = "vim.lsp.buf.rename";
        options.desc = "Rename";
      }
      {
        key = "<leader>lo";
        action.__raw = "vim.lsp.buf.document_symbol";
        options.desc = "Outline";
      }
      {
        key = "<leader>la";
        action.__raw = "vim.lsp.buf.code_action";
        options.desc = "Code Action";
      }

      # Trouble
      (trouble "x" "diagnostics filter.buf=0" "Buffer Diagnostics")
      (trouble "X" "diagnostics" "Diagnostics")
      (trouble "t" "todo" "Todo")
      (trouble "q" "qflist" "QuickFix List")
      (trouble "L" "loclist" "Location List")
      {
        key = "<leader>xv";
        action = "<cmd>TinyInlineDiag toggle<cr>";
        options.desc = "Toggle virtual text";
      }

      (trouble "l" "lsp" "LSP")
      (trouble "D" "lsp_declarations" "Declarations")
      (trouble "d" "lsp_definitions" "Definitions")
      (trouble "s" "symbols" "Symbols")
      (trouble "i" "lsp_implementations" "Implementations")
      (trouble "I" "lsp_incoming_calls" "Incoming calls")
      (trouble "O" "lsp_outgoing_calls" "Outgoing calls")
      (trouble "r" "lsp_references" "References")
      (trouble "T" "lsp_type_definitions" "type definitions")
    ];
  };
}
