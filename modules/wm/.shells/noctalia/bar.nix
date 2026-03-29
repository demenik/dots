{config, ...}: let
  monitors =
    if config.wm.primaryMonitor != null
    then [config.wm.primaryMonitor.output]
    else [];
in {
  programs.noctalia-shell.settings = {
    bar = {
      barType = "simple";
      position = "left";
      inherit monitors;
      screenOverrides = [];

      displayMode = "always_visible";
      showOnWorkspaceSwitch = true;
      hideOnOverview = false;
      autoShowDelay = 150;
      autoHideDelay = 500;
      enableExclusionZoneInset = true;

      density = "default";
      fontScale = 1;
      widgetSpacing = 6;
      contentPadding = 2;
      marginHorizontal = 4;
      marginVertical = 4;

      backgroundOpacity = 0.825;
      useSeparateOpacity = false;
      showOutline = false;
      frameThickness = 8;
      frameRadius = 12;
      outerCorners = true;

      showCapsule = true;
      capsuleColorKey = "none";
      capsuleOpacity = 1;

      mouseWheelAction = "none";
      mouseWheelWrap = true;
      reverseScroll = false;

      middleClickAction = "command";
      middleClickCommand = "systemctl restart --user linux-wallpaperengine";
      middleClickFollowMouse = false;

      rightClickAction = "controlCenter";
      rightClickFollowMouse = true;

      widgets = {
        left = [
          {
            id = "ControlCenter";
            icon = "noctalia";
            useDistroLogo = true;
            colorizeDistroLogo = false;
            enableColorization = true;
            colorizeSystemIcon = "primary";
          }
          {
            id = "Network";
            displayMode = "onhover";
            # iconColor = "none";
            # textColor = "none";
          }
          {
            id = "plugin:network-manager-vpn";
            defaultSettings = {
              connectedColor = "primary";
              disconnectedColor = "none";
              displayMode = "onhover";
            };
          }
          {
            id = "Bluetooth";
            displayMode = "onhover";
            iconColor = "none";
            textColor = "none";
          }
          {
            id = "Battery";
            deviceNativePath = "__default__";
            displayMode = "graphic";
            hideIfIdle = false;
            hideIfNotDetected = true;
            showNoctaliaPerformance = true;
            showPowerProfiles = true;
          }
          {
            id = "plugin:screen-shot-and-record";
          }
        ];

        center = [
          {
            id = "Workspace";
            followFocusedScreen = true;
            hideUnoccupied = true;
            showLabelsOnlyWhenOccupied = true;
            characterCount = 2;
            fontWeight = "bold";
            showApplications = false;
            showApplicationsHover = true;
            showBadge = true;
            pillSize = 0.6;
            iconScale = 0.8;
            enableScrollWheel = true;
            focusedColor = "primary";
            occupiedColor = "secondary";
            emptyColor = "secondary";
            unfocusedIconsOpacity = 1;
            groupedBorderOpacity = 1;
            colorizeIcons = false;
          }
        ];

        right = [
          {
            id = "Tray";
            drawerEnabled = false;
            hidePassive = false;
            colorizeIcons = true;
            pinned = [];
            blacklist = [];
          }
          {
            id = "MediaMini";
            hideMode = "hidden";
            hideWhenIdle = false;
            compactMode = false;
            useFixedWidth = false;
            maxWidth = 145;
            scrollingMode = "hover";
            showArtistFirst = true;
            showAlbumArt = true;
            panelShowAlbumArt = true;
            showVisualizer = true;
            visualizerType = "linear";
            showProgressRing = false;
          }
          {
            id = "Clock";
            useCustomFont = false;
            formatHorizontal = "HH:mm";
            formatVertical = "HH mm";
            tooltipFormat = "HH:mm dddd, d. MMMM yyyy";
          }
          {
            id = "NotificationHistory";
            showUnreadBadge = true;
            unreadBadgeColor = "primary";
            hideWhenZero = false;
            hideWhenZeroUnread = false;
          }
          {
            id = "plugin:privacy-indicator";
          }
        ];
      };
    };

    notifications = {
      enabled = true;
      location = "top_right";
      inherit monitors;
      overlayLayer = true;

      density = "compact";
      backgroundOpacity = 0.825;
      enableMarkdown = false;

      lowUrgencyDuration = 3;
      normalUrgencyDuration = 8;
      criticalUrgencyDuration = 15;
      respectExpireTimeout = false;
      clearDismissed = true;

      saveToHistory = {
        low = true;
        normal = true;
        critical = true;
      };

      enableBatteryToast = true;
      enableKeyboardLayoutToast = true;
      enableMediaToast = true;

      sounds = {
        enabled = true;
        volume = 0.5;
      };
    };
  };
}
