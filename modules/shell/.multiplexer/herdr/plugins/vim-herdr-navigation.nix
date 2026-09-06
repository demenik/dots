{
  overlays.home = [
    (final: prev: {
      vim-herdr-navigation = final.fetchFromGitHub {
        owner = "paulbkim-dev";
        repo = "vim-herdr-navigation";
        rev = "79679dacc791f70fc34de8b29a3cf9706c0f5b2f";
        hash = "sha256-iF0DLRn56eLGqY2iKTb3lX5iyVgl9CtSX5O2E5/pHjM=";
      };
    })
  ];

  home = {
    pkgs,
    lib,
    options,
    ...
  }: {
    programs.nixvim = lib.optionalAttrs (options.programs ? nixvim) {
      extraConfigLua = ''
        dofile("${pkgs.vim-herdr-navigation}/editor/nvim.lua")
      '';
    };

    programs.herdr.plugins = [pkgs.vim-herdr-navigation];

    programs.herdr.settings.keys.command = [
      {
        key = "ctrl+h";
        type = "plugin_action";
        command = "vim-herdr-navigation.left";
        description = "navigate left (vim/herdr)";
      }
      {
        key = "ctrl+j";
        type = "plugin_action";
        command = "vim-herdr-navigation.down";
        description = "navigate down (vim/herdr)";
      }
      {
        key = "ctrl+k";
        type = "plugin_action";
        command = "vim-herdr-navigation.up";
        description = "navigate up (vim/herdr)";
      }
      {
        key = "ctrl+l";
        type = "plugin_action";
        command = "vim-herdr-navigation.right";
        description = "navigate right (vim/herdr)";
      }
    ];
  };
}
