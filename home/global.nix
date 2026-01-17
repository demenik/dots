{
  user,
  pkgs,
  stateVersion,
  lib,
  config,
  ...
}: {
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
        tag.gpgsign = true;
        gpg.format = "ssh";
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

        url = {
          "ssh://git@gitlab.uni-ulm.de".insteadOf = "https://gitlab.uni-ulm.de";
          "ssh://git@github.com".insteadOf = "https://github.com";
          "ssh://git@gitea.demenik.dev".insteadOf = "https://gitea.demenik.dev";
        };

        user = {
          email = "mail@demenik.dev";
          name = "demenik";
          signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
        };

        init.defaultBranch = "main";
      };

      includes = let
        mkRemoteSsh = {
          user ? "git",
          url,
          config,
        }: {
          condition = "hasconfig:remote.*.url:${user}@${url}:*/**";
          path = "${pkgs.writeText "gitconfig-${url}" (pkgs.lib.generators.toGitINI config)}";
        };
      in [
        (mkRemoteSsh {
          url = "gitlab.uni-ulm.de";
          config.user = {
            email = "dominik.bernroider@uni-ulm.de";
            name = "Dominik Bernroider";
          };
        })
        (mkRemoteSsh {
          url = "gitea.demenik.dev";
          config.user = {
            email = "mail@demenik.dev";
            name = "demenik";
          };
        })
      ];
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
