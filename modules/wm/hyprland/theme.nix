{config, ...}: let
  c = config.colors;
in {
  wayland.windowManager.hyprland.settings = {
    general = {
      layout = "master";

      border_size = 2;
      gaps_in = 5;
      gaps_out = 5;

      "col.active_border" = "rgb(${c.base0E})";
      "col.inactive_border" = "rgb(${c.base03})";
    };

    decoration = {
      rounding = 8;

      blur = {
        size = 4;
        passes = 3;
      };
    };
  };
}
