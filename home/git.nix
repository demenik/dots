{
  pkgs,
  lib,
  config,
  ...
}: let
  pubKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAvLK5Of4imQHlPAd+2wQaKf7bTMv34RmEG2TuLvZ966 demenik@desktop";
  emails = [
    "mail@demenik.dev"
    "dominik.bernroider@uni-ulm.de"
  ];

  httpsToSsh = {
    host,
    user ? "git",
  }: {
    "ssh://${user}@${host}".insteadOf = "https://${host}";
  };

  mkRemoteSsh = {
    user ? "git",
    url,
    config,
  }: {
    condition = "hasconfig:remote.*.url:${user}@${url}:*/**";
    path = "${pkgs.writeText "gitconfig-${url}" (pkgs.lib.generators.toGitINI config)}";
  };
in {
  home.file.".ssh/allowed_signers".text =
    lib.concatMapStrings (email: "${email} ${pubKey}\n") emails;

  programs.git = {
    enable = true;

    signing = {
      key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      signByDefault = true;
      format = "ssh";
    };

    settings = {
      gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";

      init.defaultBranch = "main";

      url =
        httpsToSsh {host = "github.com";}
        // httpsToSsh {host = "gitlab.uni-ulm.de";}
        // httpsToSsh {host = "gitea.demenik.dev";};

      user = {
        email = "mail@demenik.dev";
        name = "demenik";
        signingkey = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
      };
    };

    includes = [
      (mkRemoteSsh {
        url = "gitlab.uni-ulm.de";
        config.user = {
          email = "dominik.bernroider@uni-ulm.de";
          name = "Dominik Bernroider";
        };
      })
    ];
  };
}
