{config, ...}: {
  programs.noctalia-shell.settings.wallpaper = {
    enabled = true;
    automationEnabled = false;
    useSolidColor = false;
    viewMode = "browse";
    overviewEnabled = false;

    directory = "${config.home.homeDirectory}/Nextcloud/Wallpaper";
    monitorDirectories = [];
    enableMultiMonitorDirectories = false;
    showHiddenFiles = false;
    useOriginalImages = false;
    favorites = [];

    fillMode = "crop";
    solidColor = "#1a1a2e";
    illColor = "#000000";
    linkLightAndDarkWallpapers = true;
    hideWallpaperFilenames = false;
    setWallpaperOnAllMonitors = true;

    transitionType = [
      "fade"
      "disc"
      "stripes"
      "wipe"
      "pixelate"
      "honeycomb"
    ];
    transitionDuration = 1500;
    transitionEdgeSmoothness = 0.05;
    skipStartupTransition = false;

    wallpaperChangeMode = "random";
    randomIntervalSec = 1800;
    sortOrder = "name";

    useWallhaven = false;
    wallhavenApiKey = "";
    wallhavenQuery = "";
    wallhavenCategories = "111";
    wallhavenPurity = "100";
    wallhavenSorting = "relevance";
    wallhavenOrder = "desc";
    wallhavenRatios = "";
    wallhavenResolutionMode = "atleast";
    wallhavenResolutionWidth = "";
    wallhavenResolutionHeight = "";

    overviewBlur = 0.4;
    overviewTint = 0.6;
    panelPosition = "follow_bar";
  };
}
