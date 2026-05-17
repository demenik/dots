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

  home = {
    pkgs,
    config,
    ...
  }: {
    programs.noctalia-shell = {
      # NOTE: This should be removed after noctalia-shell is updated to use the new lua hyprland configuration
      wrapper.packages = [
        (pkgs.writeShellScriptBin "hyprctl" ''
          if [[ "$1" == "dispatch" && "$2" == "--" && "$3" == "exec" ]]; then
            shift 3
            exec /run/current-system/sw/bin/hyprctl eval "hl.exec_cmd('$*')"
          else
            exec /run/current-system/sw/bin/hyprctl "$@"
          fi
        '')
      ];

      settings.appLauncher = {
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
  };
}
