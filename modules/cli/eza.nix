{
  name = "eza";

  home = {
    programs.eza = {
      enable = true;
      enableZshIntegration = true;

      colors = "auto";
      extraOptions = [
        "--classify"
        "--group-directories-first"
      ];
    };

    home.shellAliases = {
      ls = "eza";
    };
  };
}
