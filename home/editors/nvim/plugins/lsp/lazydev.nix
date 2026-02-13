{pkgs, ...}: {
  programs.nixvim = {
    plugins.lazydev = {
      enable = true;
      settings = {
        library = [
          {
            path = "${pkgs.vimPlugins.snacks-nvim}";
            words = ["Snacks"];
          }
        ];
      };
    };

    lsp.servers = {
      lua_ls.config = {
        workspace.library.__raw = ''vim.api.nvim_get_runtime_file("", true)'';
      };
    };
  };
}
