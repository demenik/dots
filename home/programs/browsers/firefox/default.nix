{
  pkgs,
  lib,
  ...
}: {
  imports = [
    ./search.nix
    # ./extensions.nix
  ];

  home.sessionVariables."BROWSER" = lib.getExe pkgs.librewolf;
  wayland.windowManager.hyprland.settings = {
    bind = ["SUPER, b, exec, librewolf"];

    env = ["BROWSER,librewolf"];

    windowrule = [
      {
        name = "librewolf";
        "match:class" = "^(librewolf)$";

        workspace = 2;
        fullscreen_state = "-1 2";
        suppress_event = "maximize";
      }
      "float on, match:class ^(librewolf)$, match:title ^(LibreWolf - Sharing Indicator)$"
      {
        name = "librewolf-pip";
        "match:class" = "^(librewolf)$";
        "match:title" = "^(Picture-in-Picture)$";

        float = true;
        keep_aspect_ratio = true;
        pin = true;
        move = "100%-w-5 100%-w-5";
      }
    ];
  };

  xdg = {
    mimeApps.defaultApplications = builtins.listToAttrs (map (key: {
        name = key;
        value = ["librewolf.desktop"];
      }) [
        "x-scheme-handler/http"
        "x-scheme-handler/https"

        "text/html"
        "text/xml"
        "application/pdf"
      ]);
  };

  programs.librewolf = {
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
