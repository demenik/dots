{
  lib,
  pkgs,
  config,
  ...
}: let
  c = config.colors.withHashtag;

  themeCustom =
    if config.theme.type == "colorScheme"
    then {
      accent = c.base0E;
      panel_bg = "reset";
      surface0 = c.base01;
      surface1 = c.base02;
      surface_dim = c.base00;
      overlay0 = c.base03;
      overlay1 = c.base04;
      text = c.base05;
      subtext0 = c.base04;
      mauve = c.base0E;
      green = c.base0B;
      yellow = c.base0A;
      red = c.base08;
      blue = c.base0D;
      teal = c.base0C;
      peach = c.base09;
    }
    else {
      accent = "{{colors.primary.default.hex}}";
      panel_bg = "reset";
      surface0 = "{{colors.surface_container_low.default.hex}}";
      surface1 = "{{colors.surface_container.default.hex}}";
      surface_dim = "{{colors.surface_dim.default.hex}}";
      overlay0 = "{{colors.outline_variant.default.hex}}";
      overlay1 = "{{colors.outline.default.hex}}";
      text = "{{colors.on_surface.default.hex}}";
      subtext0 = "{{colors.on_surface_variant.default.hex}}";
      mauve = "{{colors.tertiary.default.hex}}";
      green = "{{colors.tertiary.default.hex}}";
      yellow = "{{colors.primary_container.default.hex}}";
      red = "{{colors.error.default.hex}}";
      blue = "{{colors.primary.default.hex}}";
      teal = "{{colors.secondary.default.hex}}";
      peach = "{{colors.secondary_container.default.hex}}";
    };

  toml = pkgs.formats.toml {};
in {
  xdg.configFile."herdr/config.toml".enable = lib.mkIf (config.theme.type == "template") false;

  programs.herdr.settings = lib.mkIf (config.theme.type == "colorScheme") {
    theme.custom = themeCustom;
  };

  theme.templates.herdr-theme = lib.mkIf (config.theme.type == "template") {
    target = "~/.config/herdr/config.toml";
    post_hook = "herdr server reload-config || true";
    text = builtins.readFile (toml.generate "herdr-config-template" (
      lib.recursiveUpdate config.programs.herdr.settings {theme.custom = themeCustom;}
    ));
  };
}
