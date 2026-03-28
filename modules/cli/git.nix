{lib, ...}: {
  name = "git";
  moduleOptions = with lib; {
    git = {
      signing = {
        pubKeyPath = mkOption {
          type = types.nullOr types.str;
          default = "~/.ssh/id_ed25519.pub";
          description = "Path to SSH public key used for signing";
        };
        pubKey = mkOption {
          type = types.str;
          description = "SSH public key for allowed_signers";
        };
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
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

    mkRemoteConfig = {
      user ? "git",
      host,
      config,
    }: {
      condition = "hasconfig:remote.*.url:${user}@${host}:*/**";
      path = pkgs.writeText "gitconfig-${host}" (lib.generators.toGitINI config);
    };
  in {
    home.file.".ssh/allowed_signers".text =
      lib.concatMapStrings (email: "${email} ${config.git.signing.pubKey}\n") emails;

    programs.git = {
      enable = true;

      signing = {
        key = config.git.signing.pubKeyPath;
        signByDefault = true;
        format = "ssh";
      };

      settings = {
        gpg.ssh.allowedSignersFile = "~/.ssh/allowed_signers";
        init.defaultBranch = "main";

        url =
          lib.mkMerge
          (
            map (host: httpsToSsh {inherit host;})
            [
              "github.com"
              "gitlab.uni-ulm.de"
              "gitea.demenik.dev"
            ]
          );

        user = {
          email = "mail@demenik.dev";
          name = "demenik";
        };
      };

      includes = [
        (mkRemoteConfig {
          host = "gitlab.uni-ulm.de";
          config.user = {
            email = "dominik.bernroider@uni-ulm.de";
            name = "Dominik Bernroider";
          };
        })
      ];
    };

    programs.gh = {
      enable = true;
      settings = {
        git_protocol = "ssh";
      };
    };

    home.packages = with pkgs; [
      glab

      cocogitto
    ];
  };
}
