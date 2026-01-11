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
        @keyframes softMaskReveal {
          0% {
            -webkit-mask-position: 0% 100%;
            mask-position: 0% 100%;
            opacity: 0;
          }
          100% {
            -webkit-mask-position: 0% 0%;
            mask-position: 0% 0%;
            opacity: 1;
          }
        }

        .main-actionBarBackground-background,
        .main-entityHeader-overlay,
        .main-entityHeader-background,
        .main-entityHeader-backgroundColor {
          -webkit-mask-image: linear-gradient(to bottom, black 50%, transparent 90%);
          mask-image: linear-gradient(to bottom, black 50%, transparent 90%);
          -webkit-mask-size: 100% 200%;
          mask-size: 100% 200%;
          -webkit-mask-position: 0% 100%;
          mask-position: 0% 100%;
          animation: softMaskReveal 2s cubic-bezier(0.19, 1, 0.22, 1) forwards;
        }
      ''

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

  wayland.windowManager.hyprland.settings.windowrule = [
    "workspace 3, match:class ^(Spotify)$"
  ];
}
