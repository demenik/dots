{
  lib,
  config,
  ...
}: let
  baseDir = "${config.dots.path}/modules/editors/nvim/plugins/snippet";
in {
  programs.nixvim.extraConfigLua =
    # lua
    ''
      local snippet_commands = (function()
        ${builtins.readFile ./commands.lua}
      end)()

      snippet_commands.setup({
        base_dir = "${lib.escape ["\\" "\""] baseDir}",
      })
    '';
}
