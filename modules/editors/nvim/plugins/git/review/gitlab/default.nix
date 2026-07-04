{
  pkgs,
  lib,
  config,
  ...
}: let
  hasGitlabSecret = config.sops.secrets ? gitlab;
  secretPath =
    if hasGitlabSecret
    then config.sops.secrets.gitlab.path
    else "";
in {
  programs.nixvim = lib.mkIf hasGitlabSecret {
    extraPlugins = [
      pkgs.vimPlugins.gitlab-nvim
    ];

    extraConfigLua = ''
      require("gitlab").setup({
        auth_provider = ${import ./auth_provider.nix secretPath}
      })
    '';

    userCommands = {
      GitLabReview = {
        desc = "Start a GitLab MR review for the current branch";
        command.__raw = ''
          function()
            require("gitlab").review()
          end
        '';
      };
    };
  };
}
