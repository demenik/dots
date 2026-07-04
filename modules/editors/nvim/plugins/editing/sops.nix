{
  pkgs,
  lib,
  config,
  ...
}: {
  home = {
    packages = with pkgs; [sops];
    sessionVariables.SOPS_AGE_KEY_CMD = "${lib.getExe pkgs.ssh-to-age} -private-key -i ${config.home.homeDirectory}/.ssh/id_ed25519";
  };

  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.sops-nvim];

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
