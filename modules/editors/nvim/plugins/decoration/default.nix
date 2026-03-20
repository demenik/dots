{
  pkgs,
  config,
  ...
}: {
  programs.nixvim = {
    extraPlugins = let
      scrollEOF = pkgs.vimUtils.buildVimPlugin {
        pname = "scrollEOF.nvim";
        version = "09-14-2025";
        src = pkgs.fetchFromGitHub {
          owner = "Aasim-A";
          repo = "scrollEOF.nvim";
          rev = "e462b9a07b8166c3e8011f1dcbc6bf68b67cd8d7";
          hash = "sha256-y7yOCRSGTtQcFyWVkGe3xQqstHZMQKayxtqkOVlZ4PM=";
        };
      };
    in
      with pkgs.vimPlugins; [
        scrollEOF

        vim_current_word
      ];

    plugins = {
      noice.enable = true;

      colorizer = {
        enable = true;
        settings = {
          user_default_options = {
            RRGGBBAA = true;
          };
          filetypes = {
            "*" = {};

            nix.names_custom =
              pkgs.lib.filterAttrs
              (n: v: builtins.isString v && builtins.match "base[0-9A-F]{2}" n != null)
              config.colors.withHashtag;

            css.css = true;
            scss = {
              css = true;
              sass.enable = true;
            };
            sass = {
              css = true;
              sass.enable = true;
            };

            html.tailwind = "both";
            javascript.tailwind = "both";
            typescript.tailwind = "both";
            javascriptreact.tailwind = "both";
            typescriptreact.tailwind = "both";
          };
        };
      };
    };

    extraConfigLua = ''
      vim.cmd([[
        hi CurrentWord guifg=#cba6f7
        let g:vim_current_word#hightlight_twins = 0
        let g:vim_current_word#excluded_filetypes = ["minifiles", "netrw", "snacks_dashboard"]
      ]])
    '';
  };
}
