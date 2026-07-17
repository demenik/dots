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

  secrets = {
    gitea-token = {
      usedBy = "hm";
      required = false;
      description = "Gitea Access Token";
    };
    github-token = {
      usedBy = "hm";
      required = false;
      description = "GitHub Personal Access Token";
    };
  };

  home = {pkgs, ...}: {
    imports = [
      ./creds.nix
      ./remotes.nix
      ./signing.nix
    ];

    programs.git = {
      enable = true;

      settings = {
        init.defaultBranch = "main";
        user = {
          email = "mail@demenik.dev";
          name = "demenik";
        };
      };
    };

    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = false;
      settings = {
        git_protocol = "ssh";
      };
    };

    home.packages = with pkgs; [
      glab
      tea

      cocogitto
    ];
  };
}
