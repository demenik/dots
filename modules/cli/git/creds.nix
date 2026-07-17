{
  pkgs,
  lib,
  config,
  ...
}: let
  credHelper = user: passwordPath:
    pkgs.writeShellScript "git-cred-helper-${user}" ''
      if [ "$1" = "get" ]; then
        echo "username=${user}"
        echo "password=$(tr -d '\n' <"${passwordPath}")"
      fi
    '';
in {
  programs.git.settings = {
    "credential \"https://gitea.demenik.dev\"" = lib.mkIf (config.sops.secrets ? gitea-token) {
      helper = "!${credHelper "demenik" config.sops.secrets.gitea-token.path}";
      useHttpPath = true;
    };

    "credential \"https://github.com\"" = lib.mkIf (config.sops.secrets ? github-token) {
      helper = "!${credHelper "demenik" config.sops.secrets.github-token.path}";
    };
  };
}
