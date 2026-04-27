{
  pkgs,
  lib,
  config,
  ...
}: let
  gitlabNvimSrc = pkgs.fetchFromGitHub {
    owner = "harrisoncramer";
    repo = "gitlab.nvim";
    rev = "main";
    hash = "sha256-qLiXbeN4+14eJrfespCNc+p3qr1KCKurysbPuTsB4J8=";
  };

  gitlabNvimServer = pkgs.buildGoModule {
    pname = "gitlab-nvim-server";
    version = "latest";
    src = gitlabNvimSrc;

    vendorHash = "sha256-OLAKTdzqynBDHqWV5RzIpfc3xZDm6uYyLD4rxbh0DMg=";

    postBuild = ''
      mkdir -p "$GOPATH"/bin
      mv "$GOPATH"/bin/* "$GOPATH"/bin/server 2>/dev/null || true
    '';
  };

  gitlabNvimPlugin = pkgs.vimUtils.buildVimPlugin {
    pname = "gitlab.nvim";
    version = "latest";
    src = gitlabNvimSrc;

    dependencies = with pkgs.vimPlugins; [
      nui-nvim
      plenary-nvim
    ];

    doCheck = false;
    postInstall = ''
      mkdir -p "$out"/bin
      ln -s "${gitlabNvimServer}"/bin/server "$out"/bin/server
    '';
  };

  hasGitlabSecret = config.sops.secrets ? gitlab;
  secretPath =
    if hasGitlabSecret
    then config.sops.secrets.gitlab.path
    else "";
in {
  programs.nixvim = lib.mkIf hasGitlabSecret {
    extraPlugins = [
      gitlabNvimPlugin
    ];

    extraConfigLua = ''
      require("gitlab").setup({
        auth_provider = ${import ./auth_provider.nix secretPath}
      })
    '';

    userCommands = {
      GitLabSuggest = {
        range = true;
        desc = "Interactively create a GitLab code suggestion";
        command.__raw = builtins.readFile ./gitlab_suggest.lua;
      };
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
