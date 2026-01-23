{dotsDir, ...}: {
  programs.nh = {
    enable = true;
    flake = dotsDir;

    clean = {
      enable = true;
      dates = "weekly";
      extraArgs = "--keep 5 --keep-since 1d";
    };
  };
}
