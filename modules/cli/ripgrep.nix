{
  name = "ripgrep";

  home = {
    programs.ripgrep = {
      enable = true;
    };

    home.shellAliases = {
      grep = "rg";
    };
  };
}
