{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      selene
      stylua
    ];

    lsp.servers.lua_ls = {
      enable = true;
      config = {
        workspace.library.__raw = ''vim.api.nvim_get_runtime_file("", true)'';
      };
    };

    plugins = {
      lazydev = {
        enable = true;
        settings = {
          enabled.__raw = ''
            function(root_dir)
              return vim.g.lazydev_enabled ~= false or vim.uv.fs_stat(root_dir .. "/.nvim.lua") ~= nil
            end
          '';

          library = [
            {
              path = "${pkgs.vimPlugins.snacks-nvim}";
              words = ["Snacks"];
            }
          ];
        };
      };

      lint.lintersByFt.lua = ["selene"];

      conform-nvim.settings.formatters_by_ft.lua = ["stylua"];
    };
  };
}
