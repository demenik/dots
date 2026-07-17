{
  pkgs,
  lib,
  ...
}: let
  httpsToSsh = {
    host,
    user ? "git",
  }: {
    "ssh://${user}@${host}".insteadOf = "https://${host}";
  };

  httpsToSshPush = {
    host,
    user ? "git",
  }: {
    "ssh://${user}@${host}".pushInsteadOf = "https://${host}";
  };

  mkRemoteConfig = {
    user ? "git",
    host,
    config,
  }: let
    path = pkgs.writeText "gitconfig-${user}-${host}" (lib.generators.toGitINI config);
  in [
    {
      condition = "hasconfig:remote.*.url:${user}@${host}:*/**";
      inherit path;
    }
    {
      condition = "hasconfig:remote.*.url:ssh://${user}@${host}/**";
      inherit path;
    }
    {
      condition = "hasconfig:remote.*.url:https://${host}/**";
      inherit path;
    }
  ];
in {
  programs.git = {
    settings = {
      url = lib.mkMerge [
        (httpsToSshPush {host = "github.com";})
        (httpsToSsh {host = "gitlab.uni-ulm.de";})
        (httpsToSsh {host = "spgit.informatik.uni-ulm.de";})
      ];
    };

    includes = lib.flatten [
      (mkRemoteConfig {
        host = "gitlab.uni-ulm.de";
        config.user = {
          email = "dominik.bernroider@uni-ulm.de";
          name = "Dominik Bernroider";
        };
      })
      (mkRemoteConfig {
        host = "spgit.informatik.uni-ulm.de";
        config.user = {
          email = "dominik.bernroider@uni-ulm.de";
          name = "Dominik Bernroider";
        };
      })
    ];
  };
}
