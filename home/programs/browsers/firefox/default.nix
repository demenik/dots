{
  imports = [
    ./search.nix
    ./extensions.nix
  ];

  home.sessionVariables."BROWSER" = "firefox";
  wayland.windowManager.hyprland.settings = {
    env = ["BROWSER,firefox"];

    windowrule =
      map (rule: "${rule}, match:class ^(firefox)$") [
        "workspace 2"
        "fullscreen_state -1 2"
        "suppress_event maximize"
      ]
      ++ ["float on, match:title ^(Firefox - Sharing Indicator)$"]
      ++ map (rule: "${rule}, match:class ^(firefox)$, match:title ^(Picture-in-Picture)$") [
        "float on"
        "keep_aspect_ratio on"
        "pin on"
        "move 100%-w-5 100%-w-5"
      ];
  };

  xdg = {
    mimeApps.defaultApplications = builtins.listToAttrs (map (key: {
        name = key;
        value = ["firefox.desktop"];
      }) [
        "x-scheme-handler/http"
        "x-scheme-handler/https"

        "text/html"
        "text/xml"
        "application/pdf"
      ]);
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";

      settings = {
        "extensions.pocket.enabled" = false;

        "browser.uidensity" = 0;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.toolbars.bookmarks.visibility" = "only show on new tab";
        "browser.urlbar.suggest.addons" = false;
        "browser.urlbar.suggest.pocket" = false;

        "widget.use-xdg-desktop-portal.file-picker" = 1;

        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
      };
    };
  };
}
