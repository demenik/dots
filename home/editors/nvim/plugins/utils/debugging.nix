{
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
}
