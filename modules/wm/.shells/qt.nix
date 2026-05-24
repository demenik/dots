{
  name = "qt";

  home = {
    lib,
    config,
    ...
  }: {
    qt = {
      enable = true;
      platformTheme.name = lib.mkIf (config.theme.type == "colorScheme") "gtk";
      style.name = lib.mkIf (config.theme.type == "colorScheme") "gtk";
    };

    theme.templates.qt.enable = true;
  };
}
