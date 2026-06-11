{
  name = "element";

  modules = [../system/keyring.nix];

  moduleConfig = {
    wm.windowrules = [
      {
        matchClass = "Element";
        workspace = "3";
      }
    ];
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    catppuccinThemesFile = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/catppuccin/element/70b7ee121dcef28c6c8191d60df2f88b23c89084/config.json";
      hash = "sha256-wg6OdCvZ+ETOn8R8T/dOOTv2OQmI1MiTJzpyH8K9wLA=";
    };
    catpuccinThemes = builtins.fromJSON (builtins.readFile catppuccinThemesFile);

    inherit (config.fonts.fontconfig.defaultFonts) monospace sansSerif;

    fontsConfig = {
      general = "${builtins.elemAt sansSerif 0}, sans-serif";
      monospace = "${builtins.elemAt monospace 0}, monospace";
    };
    settings = {
      show_labs_settings = true;
      is_dark = true;
      fonts = fontsConfig;
    };
  in {
    home.packages = with pkgs; [
      element-desktop
    ];

    theme.templates.element = {
      enable = true;
      target = "~/.config/Element/config.json";
      text = builtins.toJSON (settings
        // {
          setting_defaults = {
            custom_themes = [
              {
                name = "Noctalia";
                is_dark = true;
                colors = {
                  accent-color = "{{colors.primary.default.hex}}";
                  primary-color = "{{colors.primary.default.hex}}";
                  warning-color = "{{colors.error.default.hex}}";
                  sidebar-color = "{{colors.surface_container_low.default.hex}}";
                  roomlist-background-color = "{{colors.surface_container.default.hex}}";

                  # --- Compound Backgrounds ---
                  "cpd-color-bg-canvas-default" = "{{colors.surface.default.hex}}";
                  "cpd-color-bg-subtle-primary" = "{{colors.surface_container_low.default.hex}}";
                  "cpd-color-bg-subtle-secondary" = "{{colors.surface_container.default.hex}}";
                  "cpd-color-bg-action-primary-rest" = "{{colors.primary.default.hex}}";
                  "cpd-color-bg-action-primary-hovered" = "{{colors.primary.default.hex | auto_lightness 10}}";
                  "cpd-color-bg-action-primary-pressed" = "{{colors.primary.default.hex | auto_lightness 20}}";

                  # --- Compound Text ---
                  "cpd-color-text-primary" = "{{colors.on_surface.default.hex}}";
                  "cpd-color-text-secondary" = "{{colors.on_surface_variant.default.hex}}";
                  "cpd-color-text-action-accent" = "{{colors.primary.default.hex}}";
                  "cpd-color-text-on-solid-primary" = "{{colors.on_primary.default.hex}}";
                  "cpd-color-text-disabled" = "{{colors.outline.default.hex}}";

                  # --- Compound Icons ---
                  "cpd-color-icon-primary" = "{{colors.on_surface.default.hex}}";
                  "cpd-color-icon-secondary" = "{{colors.on_surface_variant.default.hex}}";
                  "cpd-color-icon-tertiary" = "{{colors.on_surface_variant.default.hex}}";
                  "cpd-color-icon-accent-primary" = "{{colors.primary.default.hex}}";
                  "cpd-color-icon-on-solid-primary" = "{{colors.on_primary.default.hex}}";

                  # --- Compound Borders ---
                  "cpd-color-border-disabled" = "{{colors.outline_variant.default.hex}}";
                  "cpd-color-border-interactive-primary" = "{{colors.outline.default.hex}}";
                  "cpd-color-border-interactive-secondary" = "{{colors.outline_variant.default.hex}}";

                  # --- Old variables ---
                  roomlist-text-color = "{{colors.on_surface.default.hex}}";
                  roomlist-text-secondary-color = "{{colors.on_surface_variant.default.hex}}";
                  roomlist-highlights-color = "{{colors.surface_container_highest.default.hex}}";
                  roomlist-separator-color = "{{colors.outline_variant.default.hex}}";
                  timeline-background-color = "{{colors.surface.default.hex}}";
                  timeline-text-color = "{{colors.on_surface.default.hex}}";
                  secondary-content = "{{colors.on_surface.default.hex}}";
                  tertiary-content = "{{colors.on_surface.default.hex}}";
                  timeline-text-secondary-color = "{{colors.on_surface_variant.default.hex}}";
                  timeline-highlights-color = "{{colors.surface_container_high.default.hex}}";
                  reaction-row-button-selected-bg-color = "{{colors.surface_container_highest.default.hex}}";
                  menu-selected-color = "{{colors.surface_container_highest.default.hex}}";
                  focus-bg-color = "{{colors.surface_container_highest.default.hex}}";
                  room-highlight-color = "{{colors.secondary.default.hex}}";
                  togglesw-off-color = "{{colors.outline.default.hex}}";
                  other-user-pill-bg-color = "{{colors.secondary_container.default.hex}}";
                  username-colors = [
                    "{{colors.primary.default.hex}}"
                    "{{colors.secondary.default.hex}}"
                    "{{colors.tertiary.default.hex}}"
                    "{{colors.error.default.hex}}"
                    "{{colors.primary.default.hex | auto_lightness 20}}"
                    "{{colors.secondary.default.hex | auto_lightness 20}}"
                    "{{colors.tertiary.default.hex | auto_lightness 20}}"
                    "{{colors.error.default.hex | auto_lightness 20}}"
                  ];
                  avatar-background-colors = [
                    "{{colors.primary.default.hex}}"
                    "{{colors.secondary.default.hex}}"
                    "{{colors.tertiary.default.hex}}"
                  ];
                };
              }
            ];
          };
          theme = "Noctalia";
        });
    };

    xdg.configFile."Element/config.json" = lib.mkIf (config.theme.type != "template") {
      text = builtins.toJSON (lib.recursiveUpdate catpuccinThemes settings);
    };
  };
}
