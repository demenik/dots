{
  imports = [
    ./search.nix
    ./extensions.nix
  ];

  home.sessionVariables."BROWSER" = "firefox";
  wayland.windowManager.hyprland.settings = {
    env = ["BROWSER,firefox"];

    windowrulev2 =
      map (rule: "${rule}, class:^(firefox)$") [
        "workspace 2"
        "fullscreenstate -1 2"
        "suppressevent maximize"
      ]
      ++ ["float, title:^(Firefox - Sharing Indicator)$"]
      ++ map (rule: "${rule}, class:^(firefox)$, title:^(Picture-in-Picture)$") [
        "float"
        "keepaspectratio"
        "pin"
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
