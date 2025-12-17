{pkgs, ...}: {
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

      vim-hexokinase
      vim_current_word
    ];

  plugins.noice.enable = true;

  extraConfigLua = builtins.readFile ./config.lua;
}
