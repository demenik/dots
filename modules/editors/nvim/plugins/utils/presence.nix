{
  programs.nixvim = {
    plugins.cord = {
      enable = true;
      settings = {
        editor.tooltip = "Neovim";
        timestamp.shared = true;
      };
    };
  };
}
