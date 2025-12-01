{
  xdg = {
    enable = true;

    desktopEntries = let
      hide = {
        exec = "echo";
        name = "Hidden";
        noDisplay = true;
      };
    in {
      kvantummanager = hide;
      rofi = hide;
      rofi-theme-selector = hide;
      qt5ct = hide;
      qt6ct = hide;
    };
  };
}
