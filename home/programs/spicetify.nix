{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) spicetify-nix;
in {
  imports = [spicetify-nix.homeManagerModules.default];

  programs.spicetify = let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.stdenv.hostPlatform.system};
  in {
    enable = true;
    alwaysEnableDevTools = true;

    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
      fullAlbumDate
      showQueueDuration
      betterGenres
      lastfm
      playNext
      volumePercentage
      allOfArtist
    ];

    # https://github.com/spicetify/marketplace/blob/main/resources/snippets.json
    enabledSnippets = [
      # Reveals the playlist gradient header gradient with a fade in effect
      # css
      ''
        .main-entityHeader-overlay,
        .main-actionBarBackground-background,
        .main-entityHeader-overlay,
        .main-entityHeader-backgroundColor {
          -webkit-transition: 3s;
        }
      ''

      # Make the left sidebar dynamic, so it only shows when you hover over it and pushes the main content to the right.
      # css
      # ''
      #   #Desktop_LeftSidebar_Id {
      #     width: 0px;
      #     transition:
      #       width 0.5s ease,
      #       padding-left 0.5s ease;
      #     z-index: 12;
      #   }
      #   #Desktop_LeftSidebar_Id:hover {
      #     padding-left: 8px;
      #     width: 280px;
      #   }
      #   :root {
      #     margin-left: -8px;
      #   }
      #   svg[data-encore-id="icon"] {
      #     overflow: visible;
      #   }
      #   #Desktop_LeftSidebar_Id span {
      #     white-space: nowrap;
      #   }
      # ''

      # Make the search bar dynamic, so it only shows when you hover over it.
      # css
      # ''
      #   :root {
      #     margin-top: -16px;
      #   }
      #   #global-nav-bar {
      #     position: absolute;
      #     width: calc(100% + 16px);
      #     background: none;
      #     opacity: 0;
      #     z-index: 12;
      #     top: 16px;
      #     transition: opacity 0.3s ease-in-out;
      #   }
      #   #global-nav-bar:hover {
      #     z-index: 12;
      #     opacity: 1;
      #   }
      #   .Root__now-playing-bar {
      #     transform: translateY(16px);
      #   }
      #   aside[aria-label=\"Now playing bar\"] {
      #     transform: translateY(-8px);
      #   }
      #   .Root__globalNav .main-globalNav-navLink {
      #     background: none;
      #   }
      #   .e_N7UqrrJQ0fAw9IkNAL {
      #     padding-top: 56px;
      #   }
      #   .marketplace-tabBar,
      #   .marketplace-tabBar-nav {
      #     padding-top: 48px;
      #   }
      #   .marketplace-header {
      #     padding-top: 16px;
      #   }
      #   .marketplace-header__left {
      #     padding-top: 16px;
      #   }
      #   .main-topBar-background {
      #     background-color: #121212;
      #   }
      #   .liw6Y_iPu2DJRwk10x9d .FLyfurPaIDAlwjsF3mLf {
      #     display: none;
      #   }
      # ''

      # Removes gradient from home page and playlist page
      # css
      # ''
      #   .main-entityHeader-backgroundColor {
      #     display: none !important;
      #   }
      #   .main-actionBarBackground-background {
      #     display: none !important;
      #   }
      #   .main-home-homeHeader {
      #     display: none !important;
      #   }
      #   .playlist-playlist-actionBarBackground-background {
      #     display: none !important;
      #   }
      # ''

      # Hides Sidebar ScrollBar near playlist section
      # css
      ''
        #Desktop_LeftSidebar_Id .os-scrollbar-handle,
        .Root__nav-bar .os-scrollbar-handle,
        #Desktop_LeftSidebar_Id .os-scrollbar-track,
        .Root__nav-bar .os-scrollbar-track {
          visibility: hidden;
        }
      ''

      # Thin rounded modern scrollbar
      #css
      ''
        .os-scrollbar-handle {
          width: 0.25rem !important;
          border-radius: 10rem !important;
          transition: width 300ms ease-in-out;
        }
        .os-scrollbar-handle:focus,
        .os-scrollbar-handle:focus-within,
        .os-scrollbar-handle:hover {
          width: 0.35rem !important;
        }
      ''

      # Replaces the highly saturated lyrics backgrounds with a very subtle dark gradient
      #css
      ''
        .lyrics-lyrics-background {
          background-image: linear-gradient(
            315deg,
            var(--lyrics-color-background),
            black
          );
          background-size: 500%;
        }
        .lyrics-lyricsContent-lyric.lyrics-lyricsContent-highlight {
          color: white;
        }
        .lyrics-lyricsContent-lyric {
          color: #424242;
        }
      ''

      # Hides the Mini Player button.
      #css
      ''
        button:has(
          path[d="M16 2.45c0-.8-.65-1.45-1.45-1.45H1.45C.65 1 0 1.65 0 2.45v11.1C0 14.35.65 15 1.45 15h5.557v-1.5H1.5v-11h13V7H16V2.45z"]
        ),
        button:has(
          path[d="M16 2.45c0-.8-.65-1.45-1.45-1.45H1.45C.65 1 0 1.65 0 2.45v11.1C0 14.35.65 15 1.45 15h5.557v-1.5H1.5v-11h13V7H16z"]
        ) {
          display: none;
        }
      ''

      # Hides the Full Screen button.
      #css
      ''
        [data-testid=\"fullscreen-mode-button\"] {
          display: none;
        }
      ''

      # Moves the "Next in queue" section to the top of the Now Playing view
      #css
      ''
        .main-nowPlayingView-section:not(.main-nowPlayingView-queue) {
          order: 99;
        }
      ''
    ];

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace 3, class:^(Spotify)$"
  ];
}
