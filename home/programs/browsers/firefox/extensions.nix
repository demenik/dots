{pkgs, ...}: {
  programs.firefox.profiles.default.extensions = {
    force = true;

    packages = with pkgs.nur.repos.rycee.firefox-addons; [
      languagetool
      bitwarden
      yomitan
      karakeep

      firefox-color
      stylus

      betterttv
      return-youtube-dislikes

      sponsorblock
      ublock-origin
      istilldontcareaboutcookies

      react-devtools
    ];

    settings = {
      # firefox-color
      "{6AC85730-7D0F-4de0-B3FA-21142DD85326}".settings.theme = {
        colors = let
          rgb = r: g: b: {inherit r g b;};
        in {
          toolbar = rgb 30 30 46;
          toolbar_text = rgb 205 214 244;
          frame = rgb 17 17 27;
          tab_background_text = rgb 205 214 244;
          toolbar_field = rgb 24 24 37;
          toolbar_field_text = rgb 205 214 244;
          tab_line = rgb 203 166 247;
          popup = rgb 30 30 46;
          popup_text = rgb 205 214 244;
          button_background_active = rgb 108 112 134;
          frame_inactive = rgb 17 17 27;
          icons_attention = rgb 203 166 247;
          icons = rgb 203 166 247;
          ntp_background = rgb 17 17 27;
          ntp_text = rgb 205 214 244;
          popup_border = rgb 203 166 247;
          popup_highlight_text = rgb 205 214 244;
          popup_highlight = rgb 108 112 134;
          sidebar_border = rgb 203 166 247;
          sidebar_highlight_text = rgb 17 17 27;
          sidebar_highlight = rgb 203 166 247;
          sidebar_text = rgb 205 214 244;
          sidebar = rgb 30 30 46;
          tab_background_separator = rgb 203 166 247;
          tab_loading = rgb 203 166 247;
          tab_selected = rgb 30 30 46;
          tab_text = rgb 205 214 244;
          toolbar_bottom_separator = rgb 30 30 46;
          toolbar_field_border_focus = rgb 203 166 247;
          toolbar_field_border = rgb 30 30 46;
          toolbar_field_focus = rgb 30 30 46;
          toolbar_field_highlight_text = rgb 30 30 46;
          toolbar_field_highlight = rgb 203 166 247;
          toolbar_field_separator = rgb 203 166 247;
          toolbar_vertical_separator = rgb 203 166 247;
        };
        images = {
          additional_backgrounds = ["./bg-000.svg"];
          custom_backgrounds = [];
        };
        title = "Catppuccin mocha mauve";
      };

      # stylus
      "{7a7a4a92-a2a0-41d1-9fd7-1e92480d612d}".settings = {
        dbInChromeStorage = true;
      };

      # ublock-origin
      "uBlock0@raymondhill.net".settings.selectedFilterLists = [
        "user-filters"
        "ublock-filters"
        "ublock-badware"
        "ublock-privacy"
        "ublock-unbreak"
        "ublock-quick-fixes"
      ];
    };
  };
}
