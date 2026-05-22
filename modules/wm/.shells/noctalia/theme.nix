{
  config,
  lib,
  ...
}: {
  programs.noctalia-shell.settings = let
    monitor =
      if config.wm.primaryMonitor != null
      then config.wm.primaryMonitor.output
      else "";
  in {
    colorSchemes = {
      predefinedScheme = "Catppuccin";
      darkMode = true;
      syncGsettings = true;

      useWallpaperColors = true;
      generationMethod = "content";
      monitorForColors = monitor;

      schedulingMode = "off";
      manualSunrise = "06:30";
      manualSunset = "18:30";
    };
  };

  programs.noctalia-shell.user-templates.templates = lib.mapAttrs (name: t:
    lib.filterAttrs (n: v: v != null) {
      inherit (t) target text post_hook;
    })
  config.theme.templates;
}
