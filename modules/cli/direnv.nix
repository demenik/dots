{
  name = "direnv";

  home = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      silent = true;
      config.global = {
        warn_timeout = "0";
      };
    };
  };
}
