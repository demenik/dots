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

    spotifyLaunchFlags = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

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
      ".main-entityHeader-overlay,\n.main-actionBarBackground-background,\n.main-entityHeader-overlay,\n.main-entityHeader-backgroundColor {\n  -webkit-transition: 3s;\n}"
      # Make the left sidebar dynamic, so it only shows when you hover over it and pushes the main content to the right.
      # "#Desktop_LeftSidebar_Id {\n  width: 0px;\n  transition: width 0.5s ease, padding-left 0.5s ease;\n  z-index: 12;\n}\n#Desktop_LeftSidebar_Id:hover {\n  padding-left: 8px;\n  width: 280px;\n}\n:root {\n  margin-left: -8px;\n}\nsvg[data-encore-id='icon']{\n  overflow: visible;\n}\n#Desktop_LeftSidebar_Id span {\n  white-space: nowrap;\n}"
      # Make the search bar dynamic, so it only shows when you hover over it.
      # ":root {\n  margin-top: -16px;\n}\n#global-nav-bar {\n  position: absolute;\n  width: calc(100% + 16px);\n  background: none;\n  opacity: 0;\n  z-index: 12;\n  top: 16px;\n  transition: opacity 0.3s ease-in-out;\n}\n#global-nav-bar:hover {\n  z-index: 12;\n  opacity: 1;\n}\n.Root__now-playing-bar {\n  transform: translateY(16px);\n}\naside[aria-label=\"Now playing bar\"] {\n  transform: translateY(-8px);\n}\n.Root__globalNav .main-globalNav-navLink {\n  background: none;\n}\n.e_N7UqrrJQ0fAw9IkNAL {\n  padding-top: 56px;\n}\n.marketplace-tabBar, .marketplace-tabBar-nav {\n  padding-top: 48px;\n}\n.marketplace-header {\n  padding-top: 16px;\n}\n.marketplace-header__left {\n  padding-top: 16px;\n}\n.main-topBar-background {\n  background-color: #121212;\n}\n.liw6Y_iPu2DJRwk10x9d .FLyfurPaIDAlwjsF3mLf{\n  display: none;\n}"
      # Removes gradient from home page and playlist page
      # ".main-entityHeader-backgroundColor { display: none !important; } .main-actionBarBackground-background { display: none !important; } .main-home-homeHeader { display: none !important; } .playlist-playlist-actionBarBackground-background { display: none !important; }"
      # Hides Sidebar ScrollBar near playlist section
      "#Desktop_LeftSidebar_Id .os-scrollbar-handle, .Root__nav-bar .os-scrollbar-handle, #Desktop_LeftSidebar_Id .os-scrollbar-track, .Root__nav-bar .os-scrollbar-track { visibility: hidden; }"
      # Thin rounded modern scrollbar
      ".os-scrollbar-handle { width:0.25rem!important;border-radius:10rem !important; transition: width 300ms ease-in-out; } .os-scrollbar-handle:focus,.os-scrollbar-handle:focus-within,.os-scrollbar-handle:hover { width:0.35rem!important }"
      # Replaces the highly saturated lyrics backgrounds with a very subtle dark gradient
      ".lyrics-lyrics-background { background-image: linear-gradient(315deg,var(--lyrics-color-background),black); background-size: 500%; } .lyrics-lyricsContent-lyric.lyrics-lyricsContent-highlight { color: white; } .lyrics-lyricsContent-lyric { color: #424242; }"
      # Hides the Mini Player button.
      "button:has(path[d='M16 2.45c0-.8-.65-1.45-1.45-1.45H1.45C.65 1 0 1.65 0 2.45v11.1C0 14.35.65 15 1.45 15h5.557v-1.5H1.5v-11h13V7H16V2.45z']), button:has(path[d='M16 2.45c0-.8-.65-1.45-1.45-1.45H1.45C.65 1 0 1.65 0 2.45v11.1C0 14.35.65 15 1.45 15h5.557v-1.5H1.5v-11h13V7H16z']) {display: none;}"
      # Hides the Full Screen button.
      "[data-testid=\"fullscreen-mode-button\"] {display: none;}"
      # Moves the \"Next in queue\" section to the top of the Now Playing view
      ".main-nowPlayingView-section:not(.main-nowPlayingView-queue) { order: 99; }"
    ];

    theme = spicePkgs.themes.catppuccin;
    colorScheme = "mocha";
  };

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace 3, class:^(Spotify)$"
  ];
}
