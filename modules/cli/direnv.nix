{
  name = "direnv";

  nixos = {
    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;

      silent = true;
      settings.global = {
        warn_timeout = "0";
      };
    };
  };
}
