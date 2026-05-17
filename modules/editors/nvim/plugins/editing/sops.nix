{
  pkgs,
  lib,
  config,
  ...
}: let
  sops-nvim = pkgs.vimUtils.buildVimPlugin {
    pname = "sops";
    version = "2025-10-27";
    src = pkgs.fetchFromGitHub {
      owner = "trixnz";
      repo = "sops.nvim";
      rev = "5946285744ffef26b792839d9130135365bfa8ea";
      hash = "sha256-6BFgZSQwrh218genHjnldv1xnCjx4PIoXZcFYKVBlGo=";
    };
  };
in {
  home = {
    packages = with pkgs; [sops];
    sessionVariables.SOPS_AGE_KEY_CMD = "${lib.getExe pkgs.ssh-to-age} -private-key -i ${config.home.homeDirectory}/.ssh/id_ed25519";
  };

  programs.nixvim = {
    extraPlugins = [sops-nvim];

    plugins.gitsigns.settings = {
      diff_opts.internal = false;
    };
  };

  programs.git = {
    attributes = [
      "*.sops.yaml diff=sops"
      "*.sops.json diff=sops"
      "*.sops.env diff=sops"
    ];
    settings = {
      diff.sops.textconv = "${lib.getExe pkgs.sops} -d";
    };
  };
}
