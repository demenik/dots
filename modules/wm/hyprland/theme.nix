{
  lib,
  config,
  ...
}: let
  c = config.colors;
in {
  wayland.windowManager.hyprland.settings.config = {
    general = {
      layout = "master";

      border_size = 2;
      gaps_in = 5;
      gaps_out = 5;

      col = lib.mkIf (config.theme.type == "colorScheme") {
        active_border = "rgb(${c.accent})";
        inactive_border = "rgb(${c.base03})";
      };
    };

    decoration = {
      rounding = 8;

      blur = {
        size = 4;
        passes = 3;
      };
    };
  };

  theme.templates.hyprland = {
    enable = true;
    target = "~/.config/hypr/theme.lua";
    text = ''
      return {
        active_border = "rgb({{colors.primary.default.hex_stripped}})",
        inactive_border = "rgb({{colors.surface_container_highest.default.hex_stripped}})",
      }
    '';
    post_hook = "hyprctl reload";
  };

  wayland.windowManager.hyprland.extraConfig =
    lib.mkIf (config.theme.type == "template")
    # lua
    ''
      local function load_colors()
        local f = loadfile(os.getenv("HOME") .. "/.config/hypr/theme.lua")
        if f then
          local colors = f()
          hl.config({
            general = {
              col = {
                active_border = colors.active_border,
                inactive_border = colors.inactive_border,
              },
            },
          })
        end
      end
      pcall(load_colors)
    '';
}
