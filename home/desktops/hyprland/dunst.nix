{config, ...}: {
  services.dunst = {
    enable = true;

    iconTheme = {
      name = config.stylix.icons.dark;
      inherit (config.stylix.icons) package;
    };

    settings = let
      inherit (config.lib.stylix) colors;
    in {
      global = {
        width = 400;
        offset = "5x5";
        corner_radius = 8;
        transparency = 10;

        progress_bar_min_width = 380;
        progress_bar_max_width = 380;
        progress_bar_corner_radius = 8;

        padding = 10;
        horizontal_padding = 10;
        frame_width = 2;
        gap_size = 3;
      };

      urgency_low = {
        format = "<b><span>%s</span></b>\n%b";
      };

      urgency_normal = {
        highlight = colors.base0A;
        default_icon = "dialog-information";
        format = "<b><span>%s</span></b>\n%b";
      };

      urgency_critical = {
        highlight = colors.base08;
        default_icon = "dialog-error";
        format = "<b><span>%s</span></b>\n%b";
      };
    };
  };

  wayland.windowManager.hyprland.settings.layerrule = [
    "animation popin 50%, match:namespace notifications"
  ];
}
