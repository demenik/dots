{
  name = "gtk";

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
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
    gtk = {
      enable = true;

      iconTheme = let
        folderBaseColor = colors.accent;
        folderDarkColor = colors.darken folderBaseColor 12;
        folderDeepDarkColor = colors.darken folderBaseColor 65;
      in {
        name =
          if config.theme.type == "template"
          then "Papirus-Dynamic"
          else "Papirus-Dark";
        package =
          if config.theme.type == "template"
          then pkgs.papirus-icon-theme
          else
            pkgs.papirus-icon-theme.overrideAttrs (oldAttrs: {
              postInstall =
                (oldAttrs.postInstall or "")
                + ''
                  echo "patching folder icons"
                  find "$out"/share/icons -path "*/places/*" -type f -name "*.svg" -exec sed -i \
                    -e "s/#5294e2/#${folderBaseColor}/gI" \
                    -e "s/#4877b1/#${folderDarkColor}/gI" \
                    -e "s/#1d344f/#${folderDeepDarkColor}/gI" \
                    {} +
                '';
            });
      };

      theme = lib.mkIf (config.theme.type == "colorScheme") {
        name = "adw-gtk3-dark";
        package = pkgs.adw-gtk3;
      };
      gtk3.extraCss = lib.mkIf (config.theme.type == "colorScheme") gtkCss;
      gtk4 = lib.mkIf (config.theme.type == "colorScheme") {
        inherit (config.gtk) theme;
        extraCss = gtkCss;
      };
    };

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
      };
    };

    theme.templates = {
      gtk.enable = true;

      patch-icons = {
        target = "~/.local/bin/patch-papirus-icons.sh";
        post_hook = "bash ~/.local/bin/patch-papirus-icons.sh";
        text =
          # bash
          ''
            #!/usr/bin/env bash

            ICON_DIR="$HOME/.local/share/icons/Papirus-Dynamic"
            SRC_DIR="${pkgs.papirus-icon-theme}/share/icons/Papirus-Dark"

            if [ ! -d "$ICON_DIR" ]; then
              mkdir -p "$HOME/.local/share/icons"
              cp -rL "$SRC_DIR" "$ICON_DIR"
              chmod -R u+w "$ICON_DIR"
            fi

            COLOR_FILE="$ICON_DIR/.last_colors"
            if [ -f "$COLOR_FILE" ]; then
              source "$COLOR_FILE"
            else
              LAST_BASE="5294e2"
              LAST_DARK="4877b1"
              LAST_DEEP="1d344f"
            fi

            FOLDER_BASE='{{colors.primary.default.hex_stripped}}'
            FOLDER_DARK='{{colors.primary.default.hex | blend "#000000", 12 | replace "#", ""}}'
            FOLDER_DEEP='{{colors.primary.default.hex | blend "#000000", 65 | replace "#", ""}}'

            if [ "$LAST_BASE" != "$FOLDER_BASE" ] || [ "$LAST_DARK" != "$FOLDER_DARK" ] || [ "$LAST_DEEP" != "$FOLDER_DEEP" ]; then
              echo "patching folder icons dynamically from $LAST_BASE to $FOLDER_BASE"
              find "$ICON_DIR" -path "*/places/*" -type f -name "*.svg" -exec sed -i \
                -e "s/$LAST_BASE/$FOLDER_BASE/gI" \
                -e "s/$LAST_DARK/$FOLDER_DARK/gI" \
                -e "s/$LAST_DEEP/$FOLDER_DEEP/gI" \
                {} +

              echo "LAST_BASE=\"$FOLDER_BASE\"" > "$COLOR_FILE"
              echo "LAST_DARK=\"$FOLDER_DARK\"" >> "$COLOR_FILE"
              echo "LAST_DEEP=\"$FOLDER_DEEP\"" >> "$COLOR_FILE"

              gtk-update-icon-cache -f -t "$ICON_DIR" || true
            fi
          '';
      };
    };
  };
}
