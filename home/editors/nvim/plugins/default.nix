{pkgs, ...}: {
  imports = [
    ./lsp
    ./decoration
  ];

  programs.nixvim = {
    # TODO: make these hm level
    imports = [
      ./cmp
      ./editing
      ./formatting
      ./git
      ./lang
      ./snippet
      ./treesitter
      ./utils
    ];

    plugins.mini.enable = true;
    plugins.web-devicons.enable = true;

    extraPlugins = with pkgs.vimPlugins; [plenary-nvim dressing-nvim];
  };
}
