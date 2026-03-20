{
  programs.nixvim = {
    plugins.neotest.enable = true;
    extraConfigLua =
      # lua
      ''
        -- require("neotest").setup({
        --   adapters = {
        --     require("rustaceanvim.neotest")
        --   },
        -- })
      '';

    plugins.dap = {
      enable = true;

      signs = {
        dapBreakpoint = {
          text = "";
          texthl = "DiagnosticError";
          numhl = "DapBreakpoint";
        };
        dapBreakpointCondition = {
          text = "";
          texthl = "DiagnosticWarn";
          numhl = "DiagnosticWarn";
        };
        dapLogPoint = {
          text = "󱂅";
          texthl = "Comment";
          numhl = "Comment";
        };
        dapStopped = {
          text = "";
          texthl = "IncSearch";
          linehl = "CursorLine";
          numhl = "IncSearch";
        };
        dapBreakpointRejected = {
          text = "";
          texthl = "DiagnosticError";
          numhl = "DiagnosticError";
        };
      };
    };

    plugins.which-key.settings.spec = [
      {
        __unkeyed-1 = "<leader>t";
        group = "Debugging";
      }
    ];
    keymaps = [
      {
        key = "<leader>tb";
        action = "<cmd>DapToggleBreakpoint<cr>";
        options.desc = "Toggle Breakpoint";
      }
      {
        key = "<leader>td";
        action = "<cmd>DapContinue<cr>";
        options.desc = "Continue Debug Session";
      }
      {
        key = "<leader>tD";
        action = "<cmd>DapNew<cr>";
        options.desc = "New Debug Session";
      }
      {
        key = "<leader>ts";
        action = "<cmd>DapStepInto<cr>";
        options.desc = "Step Into";
      }
      {
        key = "<leader>tS";
        action = "<cmd>DapStepOver<cr>";
        options.desc = "Step Over";
      }
      {
        key = "<leader>tr";
        action.__raw = "function() require('dap').repl.toggle() end";
        options.desc = "Toggle Debug REPL";
      }

      {
        key = "<leader>tt";
        action.__raw = "function() require('neotest').run.run() end";
        options.desc = "Run nearest test";
      }
      {
        key = "<leader>tT";
        action.__raw = "function() require('neotest').run.run { strategy = 'dap' } end";
        options.desc = "Debug nearest test";
      }
      {
        key = "<leader>ta";
        action.__raw = "function() require('neotest').run.run(vim.fn.expand '%') end";
        options.desc = "Run all tests in file";
      }
    ];
  };
}
