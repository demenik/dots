{
  lib,
  config,
  ...
}: {
  programs.nixvim = lib.mkMerge [
    {
      plugins.cord = {
        enable = true;
        settings = {
          editor.tooltip = "Neovim";
          timestamp.shared = true;
        };
      };
    }

    (lib.mkIf config.programs.herdr.enable {
      plugins.cord.settings.hooks.ready.__raw =
        # lua
        ''
          function(manager)
            require("herdr-presence").attach(manager)
          end
        '';

      extraConfigLua =
        # lua
        ''
          package.loaded["herdr-presence"] = (function()
            ${builtins.readFile ./herdr.lua}
          end)()
          require("herdr-presence").setup()
        '';
    })
  ];
}
