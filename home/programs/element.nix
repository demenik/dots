{
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
    fonts = {
      general = "${config.stylix.fonts.sansSerif.name}, sans-serif";
      monospace = "${config.stylix.fonts.monospace.name}, monospace";
    };
  });

  wayland.windowManager.hyprland.settings.windowrule = [
    "workspace 3, match:class ^(Element)$"
  ];
}
