{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (config.home) homeDirectory;
  identityFile = "${homeDirectory}/.ssh/id_agenix";
in {
  programs.nixvim = {
    extraPlugins = [pkgs.vimPlugins.age-secret-nvim];
    extraPackages = [pkgs.rage-wrapped];

    extraConfigLua = ''
      require("age_secret").setup({
        identity = "${identityFile}",
      })
    '';

    plugins.gitsigns.settings = {
      diff_opts.internal = false;
    };
  };

  programs.git = {
    attributes = [
      "*.age diff=age"
    ];
    settings = {
      diff.age.textconv = "${lib.getExe pkgs.rage} -i ${identityFile} -d";
    };
  };
}
