{
  config,
  lib,
  pkgs,
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

    templates = {
      enableUserTheming = true;
      activeTemplates =
        if config.theme.type == "template"
        then
          lib.mapAttrsToList (name: t: {
            id = name;
            enabled = t.enable;
          })
          (lib.filterAttrs (name: t: t.text == null) config.theme.templates)
        else lib.mkForce [];
    };
  };

  programs.noctalia-shell.user-templates.templates = lib.mapAttrs (name: t:
    lib.filterAttrs (n: v: v != null) {
      output_path = t.target;
      input_path = pkgs.writeText "noctalia-template-${name}" t.text;
      inherit (t) post_hook;
    })
  (lib.filterAttrs (name: t: t.text != null && t.enable) config.theme.templates);
}
