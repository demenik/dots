{
  pkgs,
  lib,
  ...
}: let
  catppuccinTheme = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/catppuccin/spotify-player/08ede82f25e2a9801a1d1c1d453816ea42693754/theme.toml";
    hash = "sha256-xwa0DrhuJA+0EaHW/Nkp6kbQI0Rg3LdYOgfBBDI8Irs=";
  };
in {
  programs.spotify-player = {
    enable = true;
    package = pkgs.spotify-player.override {
      withImage = true;
    };

    keymaps = [
      {
        command = "NextTrack";
        key_sequence = "g n";
      }
      {
        command = "PreviousTrack";
        key_sequence = "g p";
      }
      {
        command = "Search";
        key_sequence = "C-c C-x /";
      }
      {
        command = "ResumePause";
        key_sequence = "M-enter";
      }
      {
        command = "None";
        key_sequence = "q";
      }
    ];

    actions = [
      {
        action = "GoToArtist";
        key_sequence = "g A";
      }
      {
        action = "GoToAlbum";
        key_sequence = "g B";
        target = "PlayingTrack";
      }
      {
        action = "ToggleLiked";
        key_sequence = "C-l";
      }
    ];

    themes = lib.mkForce (fromTOML (builtins.readFile catppuccinTheme)).themes;

    settings = {
      client_id = "5cc9ad8dbaf84bfcaaa4cf96e6bd7c31";

      theme = lib.mkForce "catppuccin-mocha";
      layout.playback_window_position = "Bottom";
      border_type = "Rounded";

      play_icon = "";
      pause_icon = "";
      liked_icon = "";
      explicit_icon = "󰬌";

      playback_format = "{status} {artists} • {track} {liked}\n{album} • {genres}\n{metadata}";
      notify_format.summary = "{artists} • {track}";

      device = {
        name = "spotify-player@thinkpad";
        device_type = "computer";
        normalization = true;
        autoplay = true;
      };
    };
  };

  xdg.desktopEntries.spotify-player = {
    name = "Spotify Player";
    genericName = "Terminal Music Player";
    comment = "Listen to music using spotify-player";
    exec = "kitty --class spotify-player -e spotify_player";
    terminal = false;
    categories = ["Audio" "Music" "Player" "AudioVideo"];
    icon = "spotify";
  };
}
