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

      (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
        pname = "ankidiscord";
        version = "2.0";
        src = pkgs.fetchFromGitHub {
          owner = "Monacraft";
          repo = "AnkiDiscord";
          rev = "f98fae9db30dd815dacdb58d374a12528d1b0f53";
          hash = "sha256-iNqrYJEJomh1nIBC+IUKYEETPgzqwRBjkuBhDLmukxk=";
        };
        sourceRoot = finalAttrs.src.name;
      }))
    ];
  };
}
