{
  config,
  pkgs,
  ...
}: let
  keyFile = config.age.secrets.anki.path;
in {
  programs.anki = {
    enable = true;
    style = "native";
    sync = {
      url = "https://anki.demenik.dev/";
      username = "demenik";
      autoSync = true;
      inherit keyFile;
    };
    addons = with pkgs.ankiAddons; [
      # recolor
      anki-connect
      passfail2
      review-heatmap
      reviewer-refocus-card
    ];
  };
}
