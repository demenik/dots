{
  lib,
  config,
  ...
}: let
  profile = config.programs.librewolf.profiles.default;
  cssPath = "${config.home.homeDirectory}/${config.programs.librewolf.profilesPath}/${profile.path}/chrome/bitwarden-theme.css";

  # Roles may carry Noctalia filters, e.g. "primary_fixed_dim | darken 10"
  color = mode: format: expr: let
    parts = lib.splitString "|" expr;
    role = lib.trim (builtins.head parts);
    filters = lib.concatMapStrings (f: " | ${lib.trim f}") (builtins.tail parts);
  in "{{colors.${role}.${mode}.${format}${filters}}}";

  # Bitwarden's legacy tokens are "r g b" triplets consumed as rgb(var(--x) / a)
  triplet = mode: expr: lib.concatMapStringsSep " " (format: color mode format expr) ["red" "green" "blue"];
  hex = mode: color mode "hex";

  decls = fmt: mode: vars:
    lib.concatStrings (lib.mapAttrsToList (name: role: "  --color-${name}: ${fmt mode role} !important;\n") vars);

  sharedLegacy = {
    shadow = "shadow";
    primary-100 = "primary_container";
    primary-300 = "inverse_primary";
    primary-600 = "primary";
    primary-700 = "on_primary_container";
    secondary-100 = "surface_container_highest";
    secondary-300 = "outline_variant";
    secondary-500 = "outline";
    secondary-600 = "on_surface_variant";
    secondary-700 = "on_surface_variant";
    danger-100 = "error_container";
    danger-600 = "error";
    danger-700 = "on_error_container";
    text-main = "on_surface";
    text-muted = "on_surface_variant";
    text-contrast = "on_primary";
  };

  illustrations = {
    light = {
      illustration-outline = "on_primary_fixed_variant | desaturate 40";
      illustration-bg-primary = "primary_container";
      illustration-bg-secondary = "primary_container | darken 10 | desaturate 20";
      illustration-bg-tertiary = "surface_container_lowest";
      illustration-tertiary = "tertiary";
      illustration-logo = "primary";
    };
    dark = {
      illustration-outline = "inverse_primary | desaturate 40 | lighten 8";
      illustration-bg-primary = "primary_fixed_dim";
      illustration-bg-secondary = "primary_fixed_dim | darken 10 | desaturate 20";
      illustration-bg-tertiary = "primary_fixed";
      illustration-tertiary = "tertiary";
      illustration-logo = "on_surface";
    };
  };

  legacy = {
    light =
      sharedLegacy
      // illustrations.light
      // {
        background = "surface_container_lowest";
        background-alt = "surface_container";
        background-alt2 = "primary";
        background-alt3 = "on_primary_fixed_variant";
        background-alt4 = "on_primary_container";
      };
    dark =
      sharedLegacy
      // illustrations.dark
      // {
        background = "surface_container";
        background-alt = "surface_container_lowest";
        background-alt2 = "surface_container_high";
        background-alt3 = "surface_container_highest";
        background-alt4 = "surface_container_lowest";
      };
  };

  # Gray steps follow Bitwarden's own light/dark token mapping (e.g. bg-primary is gray-900 in dark)
  grays = {
    light = {
      gray-050 = "surface_container_low";
      gray-100 = "surface_container_high";
      gray-200 = "outline_variant";
      gray-300 = "outline_variant";
      gray-400 = "outline";
      gray-500 = "outline";
      gray-600 = "on_surface_variant";
      gray-700 = "on_surface_variant";
      gray-800 = "on_surface";
      gray-900 = "on_surface";
      gray-950 = "on_surface";
    };
    dark = {
      gray-050 = "on_surface";
      gray-100 = "on_surface";
      gray-200 = "on_surface";
      gray-300 = "on_surface_variant";
      gray-400 = "on_surface_variant";
      gray-500 = "outline";
      gray-600 = "outline_variant";
      gray-700 = "surface_container_highest";
      gray-800 = "surface_container";
      gray-900 = "surface";
      gray-950 = "surface_container_lowest";
    };
  };

  # Main accent is brand-700 in light and brand-400 in dark, soft backgrounds sit at the far end
  brands = {
    light = {
      brand-050 = "primary_fixed";
      brand-100 = "primary_container";
      brand-200 = "primary_fixed_dim";
      brand-300 = "inverse_primary";
      brand-400 = "primary_fixed_dim";
      brand-500 = "primary";
      brand-600 = "primary";
      brand-700 = "primary";
      brand-800 = "on_primary_fixed_variant";
      brand-900 = "on_primary_container";
      brand-950 = "on_primary_fixed";
    };
    dark = {
      brand-050 = "primary_fixed";
      brand-100 = "primary_fixed";
      brand-200 = "primary_fixed";
      brand-300 = "primary_fixed_dim";
      brand-400 = "primary";
      brand-500 = "inverse_primary";
      brand-600 = "inverse_primary";
      brand-700 = "inverse_primary";
      brand-800 = "primary_container";
      brand-900 = "on_primary";
      brand-950 = "on_primary_fixed";
    };
  };

  # The inline autofill menu hardcodes colors per rule inside a closed shadow root,
  # so each rule is overridden under the theme class Bitwarden puts on its container
  inlineMenuRules = [
    {
      sels = ["body" ".inline-menu-list-heading"];
      props = {
        color = "on_surface";
        background-color = "surface_container";
      };
    }
    {
      sels = [".inline-menu-list-heading"];
      props.border-bottom-color = "surface_container";
    }
    {
      sels = [".inline-menu-list-button-container"];
      props = {
        background = "surface_container";
        border-top-color = "outline_variant";
      };
    }
    {
      sels = [
        ".inline-menu-list-heading--bordered"
        ".inline-menu-list-actions-item:not(:last-child)"
      ];
      props.border-bottom-color = "outline_variant";
    }
    {
      sels = [".inline-menu-list-actions"];
      props.border-right-color = "outline_variant";
    }
    {
      sels = [".inline-menu-list-actions::-webkit-scrollbar-thumb"];
      props.background-color = "outline_variant";
    }
    {
      sels = [
        ".inline-menu-list-button-container:hover"
        ".inline-menu-list-actions-item:hover"
        ".password-generator-actions:hover"
      ];
      props.background = "surface_container_high";
    }
    {
      sels = [
        ".inline-menu-list-message"
        ".inline-menu-list-actions-item .totp-sec-span"
        ".inline-menu-list-actions-item .cipher-name"
        ".password-generator-actions .inline-menu-list-action"
      ];
      props.color = "on_surface";
    }
    {
      sels = [
        ".inline-menu-list-button"
        ".inline-menu-list-actions-item .cipher-icon"
        ".password-generator-actions .colorized-password .password-number"
      ];
      props.color = "primary";
    }
    {
      sels = [
        ".inline-menu-list-button svg path"
        ".inline-menu-list-actions-item .view-cipher-button svg path"
        ".inline-menu-list-actions-item .cipher-icon svg path"
        ".password-generator-actions .inline-menu-list-action svg path"
        ".password-generator-actions .refresh-generated-password-button svg path"
      ];
      props.fill = "primary";
    }
    {
      sels = [
        ".inline-menu-list-message.no-items:has(:focus-visible)"
        ".inline-menu-list-message.save-login:has(:focus-visible)"
        ".inline-menu-list-button:focus:focus-visible"
        ".inline-menu-list-actions-item .cipher-container:has(:focus-visible):not(.remove-outline)"
        ".inline-menu-list-actions-item .view-cipher-button:focus:focus-visible"
        ".password-generator-actions:has(:focus-visible):not(.remove-outline)"
        ".password-generator-actions .refresh-generated-password-button:focus:focus-visible"
      ];
      props.outline-color = "primary";
    }
    {
      sels = [".inline-menu-list-actions-item .circle-color"];
      props.stroke = "primary";
    }
    {
      sels = [
        ".inline-menu-list-actions-item .totp-sec-span-danger"
        ".password-generator-actions .colorized-password .password-special"
      ];
      props.color = "error";
    }
    {
      sels = [".inline-menu-list-actions-item .circle-danger-color"];
      props.stroke = "error";
    }
    {
      sels = [
        ".inline-menu-list-actions-item .cipher-subtitle"
        ".passkey-authenticating-loader"
      ];
      props.color = "on_surface_variant";
    }
    {
      sels = [
        ".inline-menu-list-actions-item .cipher-subtitle--passkey svg"
        ".inline-menu-list-actions-item .cipher-subtitle--passkey svg path"
        ".passkey-authenticating-loader svg path"
      ];
      props.fill = "on_surface_variant";
    }
  ];

  inlineMenuCss = mode:
    lib.concatMapStrings (rule: ''
      ${lib.concatMapStringsSep ",\n" (sel: ".theme_${mode} ${sel}") rule.sels} {
      ${lib.concatStrings (lib.mapAttrsToList (prop: role: "  ${prop}: ${hex mode role} !important;\n") rule.props)}}
    '')
    inlineMenuRules;
in {
  programs.librewolf.profiles.default.userContent = lib.mkBefore ''
    @import url("file://${cssPath}");
  '';

  # Extension UUIDs are random per profile, so match the popup by path and Bitwarden's root class
  theme.templates.bitwarden = {
    target = cssPath;
    text =
      # css
      ''
        @-moz-document regexp("moz-extension://[^/]+/popup/index[.]html([?#].*)?") {
          :root.browser_firefox {
            ${decls triplet "light" legacy.light}${decls hex "light" grays.light}${decls hex "light" brands.light}
          }
          :root.browser_firefox.theme_dark {
            ${decls triplet "dark" legacy.dark}${decls hex "dark" grays.dark}${decls hex "dark" brands.dark}
          }
        }

        @-moz-document regexp("moz-extension://[^/]+/overlay/menu-list[.]html([?#].*)?") {
          ${inlineMenuCss "light"}
          ${inlineMenuCss "dark"}
        }

        @-moz-document regexp("moz-extension://[^/]+/overlay/menu-button[.]html([?#].*)?") {
          .inline-menu-button-svg-icon path[fill="#175DDC" i] {
            fill: {{colors.primary.default.hex}} !important;
          }
          .inline-menu-button-svg-icon path[fill="#fff" i] {
            fill: {{colors.on_primary.default.hex}} !important;
          }
        }

        /* Inline-styled iframe injected into every page; the button iframe has no border */
        iframe[src^="moz-extension://"][src$="/overlay/menu.html"] {
          border-color: {{colors.outline_variant.default.hex}} !important;
        }
      '';
  };
}
