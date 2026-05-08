{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      shfmt
      shellcheck
    ];

    plugins.conform-nvim = {
      enable = true;

      settings = {
        notifyOnError = true;

        formatters = {
          prettierd.env.NODE_PATH = "./node_modules";
        };

        formatters_by_ft = {
          sh = ["shellcheck" "shfmt"];
        };

        format_after_save = {
          lsp_fallback = true;
        };
      };
    };

    extraConfigLua = ''
      vim.g.slow_format_filetypes = {}
    '';
  };
}
