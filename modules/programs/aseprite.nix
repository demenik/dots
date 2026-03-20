{
  name = "asperite";

  home = {pkgs, ...}: let
    catppuccinThemeArchive = pkgs.fetchurl {
      url = "https://github.com/catppuccin/aseprite/releases/download/v1.2.1/catppuccin-theme-mocha.aseprite-extension";
      hash = "";
    };
    catppuccinTheme =
      pkgs.runCommand "extract-catppuccin-theme" {
        nativeBuildInputs = [pkgs.unzip];
      } ''
        mkdir -p "$out"
        unzip "${catppuccinThemeArchive}" -d "$out"
      '';
  in {
    home.packages = [pkgs.aseprite];

    xdg.configFile."aseprite/extensions/catppuccin-mocha" = {
      source = catppuccinTheme;
      recursive = true;
    };
  };
}
