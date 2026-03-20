{
  name = "fd";

  home = {
    programs.fd = {
      enable = true;
    };

    home.shellAliases = {
      find = "fd";
    };
  };
}
