{
  overlays.home = [
    (final: prev: {
      vim-herdr-navigation = final.fetchFromGitHub {
        owner = "paulbkim-dev";
        repo = "vim-herdr-navigation";
        rev = "7873100eb47212269005c693effb2a844986b30f";
        hash = "sha256-clp3xPU7FfcfDookBI2SDSFQLygWke3gaG0RH2T7Jy0=";
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
