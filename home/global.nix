{
  user,
  pkgs,
  stateVersion,
  lib,
  config,
  ...
}: {
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = lib.mkDefault pkgs.nix;
    settings.experimental-features = ["nix-command" "flakes"];
  };

  programs = {
    home-manager.enable = true;
    git = {
      enable = true;
      settings = {
        commit.gpgsign = true;
        gpg.format = "ssh";

        url = {
          "ssh://git@gitlab.uni-ulm.de".insteadOf = "https://gitlab.uni-ulm.de";
          "ssh://git@github.com".insteadOf = "https://github.com";
        };

        user = {
          email = "dominik.bernroider@icloud.com";
          name = "demenik";
          signingkey = "${config.home.homeDirectory}/.ssh/id_rsa";
        };

        "includeIf \"hasconfig:remote.*.url:git@gitlab.uni-ulm.de:*/**\"" = {
          path = "${pkgs.writeText ".gitconfig-gitlab.uni-ulm.de" ''
            [user]
            email = "dominik.bernroider@uni-ulm.de"
            name = "Dominik Bernroider"
          ''}";
        };

        init.defaultBranch = "main";
      };
    };
    gpg.enable = true;
  };

  services.gpg-agent = {
    enable = true;
    pinentry.package = pkgs.pinentry-curses;
  };

  home = {
    inherit stateVersion;
    username = lib.mkDefault user;
    homeDirectory = lib.mkDefault "/home/${user}";
    sessionPath = ["$HOME/.local/bin"];
  };
}
