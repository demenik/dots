{
  name = "inkscape";

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      inkscape-with-extensions
    ];
  };
}
