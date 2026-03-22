{
  pkgs,
  config,
  ...
}: {
  gtk = let
    inherit (config) colors;
    gtkCss =
      # css
      ''
        @define-color accent_color ${colors.withHashtag.accent};
        @define-color accent_bg_color ${colors.withHashtag.accent};
        @define-color accent_fg_color ${colors.withHashtag.base00};

        @define-color destructive_color ${colors.withHashtag.base08};
        @define-color destructive_bg_color ${colors.withHashtag.base08};
        @define-color destructive_fg_color ${colors.withHashtag.base00};

        @define-color success_color ${colors.withHashtag.base0B};
        @define-color success_bg_color ${colors.withHashtag.base0B};
        @define-color success_fg_color ${colors.withHashtag.base00};

        @define-color warning_color ${colors.withHashtag.base0A};
        @define-color warning_bg_color ${colors.withHashtag.base0A};
        @define-color warning_fg_color ${colors.withHashtag.base00};

        @define-color error_color ${colors.withHashtag.base08};
        @define-color error_bg_color ${colors.withHashtag.base08};
        @define-color error_fg_color ${colors.withHashtag.base00};

        @define-color window_bg_color ${colors.withHashtag.base00};
        @define-color window_fg_color ${colors.withHashtag.base05};
        @define-color view_bg_color ${colors.withHashtag.base00};
        @define-color view_fg_color ${colors.withHashtag.base05};

        @define-color headerbar_bg_color ${colors.withHashtag.base01};
        @define-color headerbar_fg_color ${colors.withHashtag.base05};
        @define-color headerbar_border_color rgba(${colors.r.base01}, ${colors.g.base01}, ${colors.b.base01}, 0.7);
        @define-color headerbar_backdrop_color @window_bg_color;
        @define-color headerbar_shade_color rgba(0, 0, 0, 0.07);
        @define-color headerbar_darker_shade_color rgba(0, 0, 0, 0.07);

        @define-color sidebar_bg_color ${colors.withHashtag.base01};
        @define-color sidebar_fg_color ${colors.withHashtag.base05};
        @define-color sidebar_backdrop_color @window_bg_color;
        @define-color sidebar_shade_color rgba(0, 0, 0, 0.07);

        @define-color secondary_sidebar_bg_color @sidebar_bg_color;
        @define-color secondary_sidebar_fg_color @sidebar_fg_color;
        @define-color secondary_sidebar_backdrop_color @sidebar_backdrop_color;
        @define-color secondary_sidebar_shade_color @sidebar_shade_color;

        @define-color card_bg_color ${colors.withHashtag.base01};
        @define-color card_fg_color ${colors.withHashtag.base05};
        @define-color card_shade_color rgba(0, 0, 0, 0.07);

        @define-color dialog_bg_color ${colors.withHashtag.base01};
        @define-color dialog_fg_color ${colors.withHashtag.base05};

        @define-color popover_bg_color ${colors.withHashtag.base01};
        @define-color popover_fg_color ${colors.withHashtag.base05};
        @define-color popover_shade_color rgba(0, 0, 0, 0.07);

        @define-color shade_color rgba(0, 0, 0, 0.07);
        @define-color scrollbar_outline_color ${colors.withHashtag.base02};

        /* Palette Overrides */
        @define-color blue_1 ${colors.withHashtag.base0D}; @define-color blue_2 ${colors.withHashtag.base0D}; @define-color blue_3 ${colors.withHashtag.base0D}; @define-color blue_4 ${colors.withHashtag.base0D}; @define-color blue_5 ${colors.withHashtag.base0D};
        @define-color green_1 ${colors.withHashtag.base0B}; @define-color green_2 ${colors.withHashtag.base0B}; @define-color green_3 ${colors.withHashtag.base0B}; @define-color green_4 ${colors.withHashtag.base0B}; @define-color green_5 ${colors.withHashtag.base0B};
        @define-color yellow_1 ${colors.withHashtag.base0A}; @define-color yellow_2 ${colors.withHashtag.base0A}; @define-color yellow_3 ${colors.withHashtag.base0A}; @define-color yellow_4 ${colors.withHashtag.base0A}; @define-color yellow_5 ${colors.withHashtag.base0A};
        @define-color orange_1 ${colors.withHashtag.base09}; @define-color orange_2 ${colors.withHashtag.base09}; @define-color orange_3 ${colors.withHashtag.base09}; @define-color orange_4 ${colors.withHashtag.base09}; @define-color orange_5 ${colors.withHashtag.base09};
        @define-color red_1 ${colors.withHashtag.base08}; @define-color red_2 ${colors.withHashtag.base08}; @define-color red_3 ${colors.withHashtag.base08}; @define-color red_4 ${colors.withHashtag.base08}; @define-color red_5 ${colors.withHashtag.base08};
        @define-color purple_1 ${colors.withHashtag.base0E}; @define-color purple_2 ${colors.withHashtag.base0E}; @define-color purple_3 ${colors.withHashtag.base0E}; @define-color purple_4 ${colors.withHashtag.base0E}; @define-color purple_5 ${colors.withHashtag.base0E};
        @define-color brown_1 ${colors.withHashtag.base0F}; @define-color brown_2 ${colors.withHashtag.base0F}; @define-color brown_3 ${colors.withHashtag.base0F}; @define-color brown_4 ${colors.withHashtag.base0F}; @define-color brown_5 ${colors.withHashtag.base0F};
        @define-color light_1 ${colors.withHashtag.base05}; @define-color light_2 ${colors.withHashtag.base05}; @define-color light_3 ${colors.withHashtag.base05}; @define-color light_4 ${colors.withHashtag.base05}; @define-color light_5 ${colors.withHashtag.base05};
        @define-color dark_1 ${colors.withHashtag.base05}; @define-color dark_2 ${colors.withHashtag.base05}; @define-color dark_3 ${colors.withHashtag.base05}; @define-color dark_4 ${colors.withHashtag.base05}; @define-color dark_5 ${colors.withHashtag.base05};
      '';
  in {
    enable = true;

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };

    theme = {
      name = "adw-gtk3-dark";
      package = pkgs.adw-gtk3;
    };
    gtk3.extraCss = gtkCss;
    gtk4.extraCss = gtkCss;
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };
}
