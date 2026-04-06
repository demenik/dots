{
  modules = [
    ../../../terminal
  ];

  moduleConfig = {
    wm.binds = [
      {
        modifiers = ["SUPER"];
        key = "Space";
        exec = "noctalia-shell ipc call launcher toggle";
      }
    ];
  };

  home = {config, ...}: {
    programs.noctalia-shell.settings.appLauncher = {
      enableClipboardHistory = false;
      enableClipPreview = true;
      enableClipboardChips = true;
      enableClipboardSmartIcons = true;
      autoPasteClipboard = false;
      clipboardWatchImageCommand = "wl-paste --type image --watch cliphist store";
      clipboardWatchTextCommand = "wl-paste --type text --watch cliphist store";
      clipboardWrapText = true;

      showCategories = true;
      sortByMostUsed = true;
      enableSessionSearch = true;
      enableSettingsSearch = true;
      enableWindowsSearch = false;

      viewMode = "list";
      density = "default";
      position = "center";
      iconMode = "tabler";
      showIconBackground = false;

      customLaunchPrefixEnabled = false;
      customLaunchPrefix = "";
      terminalCommand = config.terminal.command;

      overviewLayer = false;
      ignoreMouseInput = false;

      pinnedApps = [];
      screenshotAnnotationTool = "";
    };
  };
}
