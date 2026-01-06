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
      }))

      (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
        pname = "kanjigrid";
        version = "2.5.2";
        src = pkgs.fetchFromGitHub {
          owner = "Kuuuube";
          repo = "kanjigrid";
          rev = "f09c7dfd12bad33324f83035ae948ec0a76aa8c4";
          sparseCheckout = ["src" "data" "manifest.json"];
          hash = "sha256-2DZaJ/1auWEggTqDvJja3z39+uZw5Plkg0uLzHLyqnk=";
        };
        postPatch = ''
          mv src/* .
          rmdir src

          substituteInPlace data.py \
            --replace 'cwd + "/user_files/data"' 'os.path.expanduser("~/.local/share/Anki2/kanjigrid_user_files/data")'
        '';
      }))

      (pkgs.anki-utils.buildAnkiAddon (finalAttrs: {
        pname = "imageresizer";
        version = "1.1";
        src = pkgs.fetchFromGitHub {
          owner = "mankinence";
          repo = "ImageResizer";
          rev = "7f0b9fe3ad518d187ca9c2bc3205c6e939785330";
          sparseCheckout = ["2.1"];
          hash = "sha256-HuQWB0T41PEJ5PwVE5BTJL61dcDhwnp9VoV5A8il1dM=";
        };
        sourceRoot = "${finalAttrs.src.name}/2.1";
        postPatch = ''
          substituteInPlace __init__.py \
            --replace "os.path.join(mw.pm.addonFolder(), addon_id, 'user_files')" "os.path.expanduser('~/.local/share/Anki2/imageresizer_user_files')" \
            --replace "os.path.join(addonDir, addon_id, 'user_files')" "os.path.expanduser('~/.local/share/Anki2/imageresizer_user_files')"
        '';
      }))
    ];
  };
}
