{
  lib,
  config,
  ...
}: {
  programs.nixvim = lib.mkIf config.lang.python.enable {
    plugins = {
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
