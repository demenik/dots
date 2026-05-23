{
  name = "kitty";

  modules = [
    ./default.nix
  ];
  moduleConfig = {
    pkgs,
    lib,
    ...
  }: {
    terminal = {
      command = lib.getExe pkgs.kitty;
      windowClass = "kitty";
    };
  };

  home = {
    lib,
    config,
    ...
  }: let
    c = config.colors.withHashtag;
  in {
    programs.kitty = {
      enable = true;
      settings =
        {
          shell = config.shell.command;

          confirm_os_window_close = 0;
          dynamic_background_opacity = true;
          disable_ligatures = "always";

          background_opacity = "0.825";
          window_padding_width = 0;
        }
        // lib.optionalAttrs (config.theme.type == "colorScheme") {
          foreground = c.base05;
          background = c.base00;
          selection_foreground = c.base00;
          selection_background = c.base06;
          cursor = c.base05;
          cursor_text_color = c.base00;
          url_color = c.base0D;
          color0 = c.base00;
          color8 = c.base03;
          color1 = c.base08;
          color9 = c.base08;
          color2 = c.base0B;
          color10 = c.base0B;
          color3 = c.base0A;
          color11 = c.base0A;
          color4 = c.base0D;
          color12 = c.base0D;
          color5 = c.base0E;
          color13 = c.base0E;
          color6 = c.base0C;
          color14 = c.base0C;
          color7 = c.base05;
          color15 = c.base07;
          active_border_color = c.accent;
          inactive_border_color = c.base01;
        };

      font.name = builtins.elemAt config.fonts.fontconfig.defaultFonts.monospace 0;

      shellIntegration.enableZshIntegration = true;
    };

    theme.templates.customKitty = {
      target = "~/.config/kitty/themes/noctalia.conf";
      post_hook = "pkill -USR1 kitty || true";
      text = ''
        foreground {{colors.on_surface.default.hex}}
        background {{colors.surface.default.hex}}
        selection_foreground {{colors.on_secondary_container.default.hex}}
        selection_background {{colors.secondary_container.default.hex}}

        cursor {{colors.primary.default.hex}}
        cursor_text_color {{colors.on_primary.default.hex}}
        cursor_trail_color {{colors.surface_variant.default.hex}}

        url_color {{colors.tertiary.default.hex}}

        active_border_color {{colors.primary.default.hex}}
        inactive_border_color {{colors.surface_variant.default.hex}}

        active_tab_foreground {{colors.on_primary_container.default.hex}}
        active_tab_background {{colors.primary_container.default.hex}}
        inactive_tab_foreground {{colors.on_surface_variant.default.hex}}
        inactive_tab_background {{colors.surface_variant.default.hex}}

        color0 {{colors.surface_container_highest.default.hex}}
        color8 {{colors.outline.default.hex}}

        color1 {{colors.primary.default.hex | blend "#FF0000", 0.6 | set_saturation 80}}
        color9 {{colors.primary.default.hex | blend "#FF0000", 0.6 | set_saturation 80 | auto_lightness 20}}

        color2 {{colors.primary.default.hex | blend "#00FF00", 0.6 | set_saturation 80}}
        color10 {{colors.primary.default.hex | blend "#00FF00", 0.6 | set_saturation 80 | auto_lightness 20}}

        color3 {{colors.primary.default.hex | blend "#FFFF00", 0.6 | set_saturation 80}}
        color11 {{colors.primary.default.hex | blend "#FFFF00", 0.6 | set_saturation 80 | auto_lightness 20}}

        color4 {{colors.primary.default.hex | blend "#0000FF", 0.6 | set_saturation 80}}
        color12 {{colors.primary.default.hex | blend "#0000FF", 0.6 | set_saturation 80 | auto_lightness 20}}

        color5 {{colors.primary.default.hex | blend "#FF00FF", 0.6 | set_saturation 80}}
        color13 {{colors.primary.default.hex | blend "#FF00FF", 0.6 | set_saturation 80 | auto_lightness 20}}

        color6 {{colors.primary.default.hex | blend "#00FFFF", 0.6 | set_saturation 80}}
        color14 {{colors.primary.default.hex | blend "#00FFFF", 0.6 | set_saturation 80 | auto_lightness 20}}

        color7 {{colors.on_surface.default.hex}}
        color15 {{colors.on_surface.default.hex | auto_lightness 20}}
      '';
    };
    programs.kitty.extraConfig = lib.optionalString (config.theme.type == "template") ''
      include themes/noctalia.conf
    '';

    home.shellAliases = {
      ssh = "kitten ssh";
    };
  };
}
