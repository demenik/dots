{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      sqlfluff
    ];

    plugins = {
      lsp.servers = {
        sqruff = {
          enable = true;
          config.sqruff.indentation = {
            indent_unit = "space";
            tab_space_size = 2;
          };
        };
        graphql.enable = true;
      };

      lint.lintersByFt = {
        sql = ["sqlfluff"];
      };

      conform-nvim.settings.formatters_by_ft = {
        sql = ["sqruff"];
      };
    };
  };
}
