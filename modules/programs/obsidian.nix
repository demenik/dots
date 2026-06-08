{
  name = "obsidian";

  moduleConfig = {
    wm.windowrules = [
      {
        matchClass = "obsidian";
        workspace = "1";
      }
    ];
  };

  home = {pkgs, ...}: {
    home.packages = with pkgs; [obsidian];

    theme.templates.obsidian = {
      enable = true;
      target = "~/.config/noctalia/obsidian-theme.css";
      post_hook =
        # bash
        ''
          for vault in ~/Documents/Obsidian/*; do
            if [ -d "$vault/.obsidian" ]; then
              mkdir -p "$vault/.obsidian/snippets"
              cp ~/.config/noctalia/obsidian-theme.css "$vault/.obsidian/snippets/noctalia.css"
            fi
          done
        '';
      text =
        # css
        ''
          .theme-dark, .theme-light {
            /* Backgrounds */
            --background-primary: {{colors.surface.default.hex}};
            --background-primary-alt: {{colors.surface_container_lowest.default.hex}};
            --background-secondary: {{colors.surface_container.default.hex}};
            --background-secondary-alt: {{colors.surface_container_high.default.hex}};
            --background-modifier-border: rgba({{colors.outline.default.rgb_csv}}, 0.15);
            --background-modifier-border-hover: rgba({{colors.outline.default.rgb_csv}}, 0.3);
            --background-modifier-border-focus: rgba({{colors.primary.default.rgb_csv}}, 0.5);

            /* Text */
            --text-normal: {{colors.on_surface.default.hex}};
            --text-muted: {{colors.on_surface_variant.default.hex}};
            --text-faint: {{colors.surface_variant.default.hex}};

            --h1-color: {{colors.primary.default.hex}} !important;
            --h2-color: {{colors.primary.default.hex}} !important;
            --h3-color: {{colors.primary.default.hex}} !important;
            --h4-color: {{colors.primary.default.hex}} !important;
            --h5-color: {{colors.primary.default.hex}} !important;
            --h6-color: {{colors.primary.default.hex}} !important;
            --bold-color: {{colors.secondary.default.hex}} !important;
            --italic-color: {{colors.tertiary.default.hex}} !important;

            /* Accents */
            --text-accent: {{colors.primary.default.hex}};
            --text-accent-hover: {{colors.secondary.default.hex}};
            --interactive-accent: {{colors.primary.default.hex}};
            --interactive-accent-hover: {{colors.secondary.default.hex}};

            /* UI */
            --interactive-normal: {{colors.surface_container_highest.default.hex}};
            --interactive-hover: {{colors.surface_dim.default.hex}};

            --checkbox-color: {{colors.primary.default.hex}};
            --checklist-done-color: {{colors.primary.default.hex}};

            /* Callouts */
            --callout-bug: {{colors.error.default.rgb_csv}};
            --callout-default: {{colors.primary.default.rgb_csv}};
            --callout-error: {{colors.error.default.rgb_csv}};
            --callout-example: {{colors.tertiary.default.rgb_csv}};
            --callout-fail: {{colors.error.default.rgb_csv}};
            --callout-important: {{colors.secondary.default.rgb_csv}};
            --callout-info: {{colors.primary.default.rgb_csv}};
            --callout-question: {{colors.secondary.default.rgb_csv}};
            --callout-success: {{colors.primary.default.rgb_csv}};
            --callout-summary: {{colors.secondary.default.rgb_csv}};
            --callout-tip: {{colors.secondary.default.rgb_csv}};
            --callout-todo: {{colors.primary.default.rgb_csv}};
            --callout-warning: {{colors.error.default.rgb_csv}};
            --callout-quote: {{colors.surface_variant.default.rgb_csv}};
          }

          .markdown-rendered h1,
          .markdown-rendered h2,
          .markdown-rendered h3,
          .markdown-rendered h4,
          .markdown-rendered h5,
          .markdown-rendered h6,
          .cm-s-obsidian .cm-header {
            color: {{colors.primary.default.hex}} !important;
          }

          .markdown-rendered strong,
          .cm-s-obsidian .cm-strong {
            color: {{colors.secondary.default.hex}} !important;
          }

          .markdown-rendered em,
          .cm-s-obsidian .cm-em {
            color: {{colors.tertiary.default.hex}} !important;
          }

          @media print {
            .markdown-rendered h1,
            .markdown-rendered h2,
            .markdown-rendered h3,
            .markdown-rendered h4,
            .markdown-rendered h5,
            .markdown-rendered h6,
            .markdown-rendered strong,
            .markdown-rendered em {
              color: #000000 !important;
            }
          }
        '';
    };
  };
}
