{lib, ...}: {
  name = "browser";

  moduleOptions = with lib; {
    browser = {
      command = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Command to start the browser";
      };
      windowClass = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Window class of the browser";
      };
      desktopFileName = mkOption {
        type = types.nullOr types.str;
        default = null;
        description = "Name of the .desktop file of the browser";
      };
    };
  };

  moduleConfig = {
    lib,
    config,
    ...
  }: {
    wm = {
      binds = lib.mkIf (config.browser.command != null) [
        {
          modifiers = ["SUPER"];
          key = "b";
          exec = config.browser.command;
        }
      ];

      windowrules = lib.mkIf (config.browser.windowClass != null) [
        {
          matchClass = config.browser.windowClass;
          workspace = "2";
        }
      ];
    };
  };

  home = {
    lib,
    config,
    ...
  }: {
    home.sessionVariables = lib.mkIf (config.browser.command != null) {
      BROWSER = config.browser.command;
    };

    xdg.mimeApps = lib.mkIf (config.browser.desktopFileName != null) {
      defaultApplications = builtins.listToAttrs (map (key: {
          name = key;
          value = [config.browser.desktopFileName];
        }) [
          "x-scheme-handler/http"
          "x-scheme-handler/https"

          "text/html"
          "text/xml"
          "application/pdf"
        ]);
    };
  };
}
