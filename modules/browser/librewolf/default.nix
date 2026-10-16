{
  name = "librewolf";

  modules = [../default.nix];
  moduleConfig = {
    pkgs,
    lib,
    ...
  }: {
    browser = {
      command = lib.getExe pkgs.librewolf;
      windowClass = "librewolf";
      desktopFileName = "librewolf.desktop";
    };

    wm.windowrules = [
      {
        matchClass = "librewolf";
        matchTitle = "Picture-in-Picture";

        floating = true;
        keepAspectRatio = true;
        pinned = true;
        position = ["100%-w-5" "100%-h-5"];
      }
    ];
  };

  home = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      ./containers.nix
      ./extensions
      ./search.nix
    ];

    home.packages = with pkgs; [
      nerd-fonts.symbols-only
    ];

    programs.librewolf = {
      enable = true;
      package = pkgs.librewolf;

      profiles.default = {
        name = "Default";

        settings = {
          "extensions.pocket.enabled" = false;

          "browser.urlbar.suggest.engines" = false;
          "browser.urlbar.suggest.openpage" = false;
          "browser.urlbar.suggest.bookmark" = true;
          "browser.toolbars.bookmarks.visibility" = "never";
          "browser.urlbar.suggest.addons" = false;
          "browser.urlbar.suggest.pocket" = false;

          "widget.use-xdg-desktop-portal.file-picker" = 1;

          "browser.formfill.enable" = false;
          "extensions.formautofill.addresses.enabled" = false;
          "security.warn_submit_secure_to_insecure" = false;

          "browser.startup.page" = 3; # restore
          "privacy.sanitize.sanitizeOnShutdown" = false;
          "privacy.clearOnShutdown_v2.cookiesAndStorage" = false;
          "privacy.clearOnShutdown_v2.formdata" = true;
          "identity.fxaccounts.enabled" = true;

          "privacy.resistFingerprinting" = false;
          "privacy.fingerprintingProtection" = true;
          "privacy.spoof_english" = 2;
          "layout.css.font-visibility.resistFingerprinting" = 3;
          "layout.css.font-visibility.trackingprotection" = 3;
          "dom.security.https_only_mode" = false;
          "media.eme.enabled" = true;

          "browser.tabs.inTitlebar" = 1;
          "sidebar.visibility" = "hide-on-close";
          "widget.gtk.overlay-scrollbars.enabled" = false;
          "general.autoScroll" = true;
          "findbar.highlightAll" = true;
          "layout.spellcheckDefault" = 0;
          "browser.bookmarks.showMobileBookmarks" = false;
          "browser.download.useDownloadDir" = true;
          "browser.ml.enable" = true;

          "browser.translations.automaticallyPopup" = false;
          "browser.translations.alwaysTranslateLanguages" = "ru";
          "browser.translations.neverTranslateLanguages" = "de";

          "font.name.monospace.x-western" = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
          "font.name.sans-serif.x-western" = builtins.head config.fonts.fontconfig.defaultFonts.sansSerif;
          "font.name.serif.x-western" = builtins.head config.fonts.fontconfig.defaultFonts.serif;
        };

        userChrome = import ./userChrome {
          font = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
        };

        userContent = let
          inherit (config.fonts.fontconfig.defaultFonts) monospace emoji;
        in ''
          code, kbd, pre, samp, tt {
            font-family: "${builtins.head monospace}", "${builtins.head emoji}", "Symbols Nerd Font", monospace !important;
            font-variant-ligatures: none;
          }
        '';
      };
    };
  };
}
