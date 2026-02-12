{
  pkgs,
  user,
  ...
}: let
  age-secret-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "age-secret";
    src = pkgs.fetchFromGitHub {
      owner = "histrio";
      repo = "age-secret.nvim";
      rev = "9be5fbdac534422dc7d03eccb9d5af96f242e16f";
      hash = "sha256-3RMSaUfZyMq9aNwBrdVIP4Mh80HwIcO7I+YhFOw+NU8=";
    };
  };
in {
  programs.nixvim = {
    extraPlugins = [age-secret-nvim];
    extraPackages = [pkgs.rage];

    extraConfigLua = ''
      require("age_secret").setup {
        identity = "~/.ssh/id_agenix",
      }
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
      diff.age.textconv = "${pkgs.lib.getExe pkgs.rage} -d -i /home/${user}/.ssh/id_agenix";
    };
  };
}
