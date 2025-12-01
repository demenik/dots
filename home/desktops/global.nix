{
  pkgs,
  inputs,
  ...
}: {
  home = {
    sessionVariables = {
      GTK_USE_PORTAL = "1";
      NIXOS_OZONE_WL = "1";
      QT_SCALE_FACTOR = "1";
      DISABLE_QT5_COMPAT = "0";
      _JAVA_AWT_WM_NONREPARENTING = "1";
      QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    };
  };

  qt = {
    enable = true;
    platformTheme.name = "qtct";
  };
}
