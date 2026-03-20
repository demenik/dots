{
  name = "element";

  moduleConfig = {
    wm.windowrules = [
      {
        matchClass = "Element";
        workspace = "3";
      }
    ];
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    catppuccinThemesFile = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/element/70b7ee121dcef28c6c8191d60df2f88b23c89084/config.json";
      hash = "sha256-wg6OdCvZ+ETOn8R8T/dOOTv2OQmI1MiTJzpyH8K9wLA=";
    };
    catpuccinThemes = builtins.fromJSON (builtins.readFile catppuccinThemesFile);
  in {
    home.packages = with pkgs; [
      element-desktop
    ];

    xdg.configFile."Element/config.json".text = builtins.toJSON (lib.recursiveUpdate catpuccinThemes {
      is_dark = true;
      fonts = let
        inherit (config.fonts.fontconfig.defaultFonts) monospace sansSerif;
      in {
        general = "${builtins.elemAt sansSerif 0}, sans-serif";
        monospace = "${builtins.elemAt monospace 0}, monospace";
      };
    });
  };
}
