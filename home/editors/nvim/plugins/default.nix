{pkgs, ...}: {
  imports = [
    ./cmp
    ./decoration
    ./editing
    ./formatting
    ./git
    ./lang
    ./lsp
    ./snippet
    ./treesitter
    ./utils
  ];

  programs.nixvim = {
    plugins.mini.enable = true;
    plugins.web-devicons.enable = true;

    extraPlugins = with pkgs.vimPlugins; [plenary-nvim dressing-nvim];
  };
}
