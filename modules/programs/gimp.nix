{
  name = "gimp";

  home = {pkgs, ...}: {
    home.packages = [pkgs.gimp];
  };
}
