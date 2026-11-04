{
  name = "thunderbird";

  overlays.home = [
    (final: prev: {
      thunderbird-catppuccin-theme = final.stdenv.mkDerivation {
        name = "catppuccin-thunderbird";
        src = final.fetchFromGitHub {
          owner = "catppuccin";
          repo = "thunderbird";
          rev = "575ab278460137dba10c1a23d00af0bc583fe509";
          hash = "sha256-ScuymVAaJ0FL6hJkHIiGuPI15XJsq+6Y/qKm/nUUNp4=";
        };

        installPhase = ''
          mkdir -p "$out"
          cp -r "$src"/themes/mocha/mocha-mauve.xpi "$out"/catppuccin-mocha-mauve.xpi
        '';
      };
    })
  ];

  home = {pkgs, ...}: {
    programs.thunderbird = {
      enable = true;

      profiles = {
        default = {
          isDefault = true;
          settings = {
            "mail.ui.folderpane.view" = 2;
            # "mail.account.special_folders.global_inbox" = 1;
            "extensions.autoDisableScopes" = 0;

            "layout.spellcheckDefault" = 2;
            "spellchecker.dictionary" = "de-DE,en-US";
            "mail.spellcheck.inline" = true;
          };

          extensions = [
            pkgs.thunderbird-catppuccin-theme
          ];
        };
      };
    };
  };
}
