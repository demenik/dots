{
  name = "zoxide";

  home = {
    programs.zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    home.shellAliases = {
      cd = "z";
    };
  };
}
