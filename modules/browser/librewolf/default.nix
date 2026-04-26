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

          "font.name.monospace.x-western" = builtins.head config.fonts.fontconfig.defaultFonts.monospace;
          "font.name.sans-serif.x-western" = builtins.head config.fonts.fontconfig.defaultFonts.sansSerif;
          "font.name.serif.x-western" = builtins.head config.fonts.fontconfig.defaultFonts.serif;
        };

        userChrome = import ./userChrome;

        userContent = let
          inherit (config.fonts.fontconfig.defaultFonts) monospace emoji;
        in ''
          code, kbd, pre, samp, tt {
            font-family: "${builtins.head monospace}", "${builtins.head emoji}", "Symbols Nerd Font", monospace !important;
          }
        '';
      };
    };
  };
}
