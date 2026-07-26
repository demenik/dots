{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.nixvim = lib.mkIf config.lang.web.enable {
    extraPlugins = with pkgs.vimPlugins; [
      template-string-nvim
    ];

    extraConfigLua =
      # lua
      ''
        require("template-string").setup {
          remove_template_string = true,
          restore_quotes = {
            normal = [["]],
            jsx = [["]],
          },
        }
      '';
  };
}
