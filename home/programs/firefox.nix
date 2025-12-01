{lib, ...}: {
  home.sessionVariables."BROWSER" = "firefox";
  wayland.windowManager.hyprland.settings = {
    env = ["BROWSER,firefox"];

    windowrulev2 =
      [
        "workspace 2, class:^(firefox)$"
        "fullscreenstate -1 2, class:^(firefox)$"
        "float, title:^(Firefox - Sharing Indicator)$"
        "suppressevent maximize, class:^(firefox)$"
      ]
      ++ map (rule: "${rule}, class:^(firefox)$, title:^(Picture-in-Picture)$") [
        "float"
        "keepaspectratio"
        "pin"
        "move 100%-w-5 100%-w-5"
      ];
  };

  xdg = {
    mimeApps.defaultApplications = builtins.listToAttrs (builtins.map (key: {
        name = key;
        value = ["firefox.desktop"];
      }) [
        "x-scheme-handler/http"
        "x-scheme-handler/https"

        "text/html"
        "text/xml"
        "application/pdf"
      ]);
  };

  programs.firefox = {
    enable = true;
    profiles.default = {
      name = "Default";

      settings = {
        "extensions.pocket.enabled" = false;

        "browser.uidensity" = 0;
        "browser.urlbar.suggest.engines" = false;
        "browser.urlbar.suggest.openpage" = false;
        "browser.urlbar.suggest.bookmark" = true;
        "browser.toolbars.bookmarks.visibility" = "only show on new tab";
        "browser.urlbar.suggest.addons" = false;
        "browser.urlbar.suggest.pocket" = false;

        "widget.use-xdg-desktop-portal.file-picker" = 1;

        "browser.formfill.enable" = false;
        "extensions.formautofill.addresses.enabled" = false;
      };

      search = {
        force = true;

        default = "ud";
        order = [
          "ud"

          "no"
          "np"
          "hm"

          "nv"
          "lsp"

          "crates"
        ];

        engines = let
          mkParams = lib.mapAttrsToList (name: value: {
            inherit name value;
          });

          mkEngine = {
            icon,
            template,
            params ? {},
            definedAliases ? [],
          }: {
            inherit icon definedAliases;
            urls = [
              {
                inherit template;
                params = mkParams params;
              }
            ];
          };
        in {
          ud = mkEngine {
            icon = "https://www.gstatic.com/images/branding/searchlogo/ico/favicon.ico";
            template = "https://unduck.demenik.tech";
            params = {q = "{searchTerms}";};
          };

          np = mkEngine {
            icon = "https://search.nixos.org/images/nix-logo.png";
            definedAliases = ["@np"];
            template = "https://search.nixos.org/packages";
            params = {
              type = "packages";
              channel = "unstable";
              query = "{searchTerms}";
            };
          };
          no = mkEngine {
            icon = "https://search.nixos.org/images/nix-logo.png";
            definedAliases = ["@no"];
            template = "https://search.nixos.org/options";
            params = {
              channel = "unstable";
              query = "{searchTerms}";
            };
          };
          hm = mkEngine {
            icon = "https://home-manager-options.extranix.com/images/favicon.png";
            definedAliases = ["@hm"];
            template = "https://home-manager-options.extranix.com";
            params = {
              release = "master";
              query = "{searchTerms}";
            };
          };

          nv = mkEngine {
            icon = "https://raw.githubusercontent.com/nix-community/nixvim/main/assets/nixvim_logo.svg";
            definedAliases = ["@nv"];
            template = "https://nix-community.github.io/nixvim/";
            params = {
              search = "{searchTerms}";
            };
          };
          lsp = mkEngine {
            icon = "https://github.com/neovim.png";
            definedAliases = ["@lsp"];
            template = "https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#{searchTerms}";
          };

          crates = mkEngine {
            icon = "https://crates.io/assets/cargo.png";
            definedAliases = ["@crates"];
            template = "https://crates.io/search";
            params = {
              q = "{searchTerms}";
            };
          };
        };
      };
    };
  };
}
