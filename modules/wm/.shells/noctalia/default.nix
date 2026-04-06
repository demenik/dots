{
  name = "noctalia";

  modules = [
    ../../default.nix
    ./plugins
    ./launcher.nix
  ];

  home = {
    inputs,
    lib,
    config,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default

      ./bar.nix
      ./hardware.nix
      ./locker.nix
      ./panels.nix
      ./wm.nix
    ];

    systemd.user.services.noctalia = {
      Unit = {
        Description = "Noctalia Shell";
        After = ["graphical-session-pre.target"];
        PartOf = ["graphical-session.target"];
        X-Restart-Triggers = [
          (builtins.toJSON config.programs.noctalia-shell.settings)
        ];
      };
      Service = {
        ExecStart = lib.getExe config.programs.noctalia-shell.package;
        Restart = "on-failure";
        RestartSec = 1;
      };
      Install.WantedBy = ["graphical-session.target"];
    };

    programs.noctalia-shell = let
      monitor =
        if config.wm.primaryMonitor != null
        then config.wm.primaryMonitor.output
        else "";

      monitors =
        if monitor != ""
        then [monitor]
        else [];
    in {
      enable = true;
      settings = {
        settingsVersion = 59;

        general = {
          language = "";
          avatarImage = "${config.home.homeDirectory}/.face";
          showChangelogOnStartup = true;
          telemetryEnabled = false;
          autoStartAuth = true;

          animationDisabled = false;
          animationSpeed = 1.5;
          enableBlurBehind = true;
          enableShadows = false;
          shadowOffsetX = 2;
          shadowOffsetY = 3;

          lockOnSuspend = true;
          lockScreenMonitors = monitors;
          lockScreenAnimations = true;
          lockScreenBlur = 0;
          lockScreenTint = 0;
          compactLockScreen = false;
          enableLockScreenCountdown = true;
          lockScreenCountdownDuration = 10000;
          enableLockScreenMediaControls = true;
          showSessionButtonsOnLockScreen = true;
          showHibernateOnLockScreen = false;
          allowPasswordWithFprintd = true;
          passwordChars = true;

          smoothScrollEnabled = true;
          reverseScroll = false;
          allowPanelsOnScreenWithoutBar = true;
          dimmerOpacity = 0.2;

          clockStyle = "custom";
          clockFormat = "hh\\nmm";
        };

        ui = {
          fontDefault = "Ubuntu Nerd Font";
          fontDefaultScale = 1;
          fontFixed = "monospace";
          fontFixedScale = 1;

          panelsAttachedToBar = true;
          panelBackgroundOpacity = 0.825;
          translucentWidgets = true;
          boxBorderEnabled = true;

          settingsPanelMode = "attached";
          settingsPanelSideBarCardStyle = true;

          tooltipsEnabled = true;
          scrollbarAlwaysVisible = false;
        };
        colorSchemes = {
          darkMode = true;
          predefinedScheme = "Catppuccin";
          useWallpaperColors = false;
          generationMethod = "tonal-spot";
          monitorForColors = monitor;

          schedulingMode = "off";
          manualSunrise = "06:30";
          manualSunset = "18:30";

          syncGsettings = true;
        };

        location = {
          name = "Stuttgart";
          use12hourFormat = false;
          firstDayOfWeek = 1;

          weatherEnabled = false;
          weatherShowEffects = true;
          useFahrenheit = false;
          hideWeatherCityName = false;
          hideWeatherTimezone = false;

          showCalendarEvents = true;
          showCalendarWeather = false;
          showWeekNumberInCalendar = true;
          analogClockInCalendar = false;
        };

        noctaliaPerformance = {
          disableDesktopWidgets = true;
          disableWallpaper = true;
        };

        wallpaper.enabled = false;
      };
    };
  };
}
