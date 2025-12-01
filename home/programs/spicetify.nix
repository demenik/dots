{
  inputs,
  pkgs,
  ...
}: let
  inherit (inputs) spicetify-nix;
in {
  imports = [spicetify-nix.homeManagerModules.default];

  programs.spicetify = let
    spicePkgs = spicetify-nix.legacyPackages.${pkgs.system};
  in {
    enable = true;

    spotifyLaunchFlags = "--enable-features=UseOzonePlatform --ozone-platform=wayland";

    enabledExtensions = with spicePkgs.extensions; [
      keyboardShortcut
      shuffle
      groupSession
      fullAlbumDate
      showQueueDuration
      betterGenres
      lastfm
      playNext
      volumePercentage
      allOfArtist
    ];
  };

  wayland.windowManager.hyprland.settings.windowrulev2 = [
    "workspace 3, class:^(Spotify)$"
  ];
}
