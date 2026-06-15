{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      ruff
      black
      python312Packages.flake8
    ];

    lsp.servers.pyright.enable = true;

    plugins = {
      lint.lintersByFt.python = ["ruff"];

      conform-nvim.settings.formatters_by_ft.python = ["black"];

      noice.settings.routes = [
        {
          filter = {
            event = "lsp";
            kind = "progress";
            cond.__raw = ''
              function(message)
                local client = vim.tbl_get(message.opts, "progress", "client")
                return client == "pyright"
              end
            '';
          };
          opts.skip = true;
        }
      ];
    };
  };
}
