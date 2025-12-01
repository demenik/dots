{pkgs, ...}: {
  programs.thunderbird = {
    enable = true;

    profiles.default = {
      isDefault = true;

      settings = {
        "mail.ui.folderpane.view" = 2;
        # "mail.account.special_folders.global_inbox" = 1;
        "extensions.autoDisableScopes" = 0;
      };

      extensions = let
        catppuccin-theme = pkgs.stdenv.mkDerivation {
          name = "catppuccin-thunderbird";
          src = pkgs.fetchFromGitHub {
            owner = "catppuccin";
            repo = "thunderbird";
            rev = "0289f3bd9566f9666682f66a3355155c0d0563fc";
            hash = "sha256-07gT37m1+OhRTbUk51l0Nhx+I+tl1il5ayx2ow23APY=";
          };

          installPhase = ''
            mkdir -p $out
            cp -r $src/themes/mocha/mocha-mauve.xpi $out/catppuccin-mocha-mauve.xpi
          '';
        };
      in [
        catppuccin-theme
      ];
    };
  };
}
