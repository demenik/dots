{
  pkgs,
  lib,
  config,
  ...
}: {
  programs.niri.settings.binds = with config.lib.niri.actions;
    {
      "Mod+Shift+Q".action = quit;

      "Mod+X".action = close-window;
      "Mod+T".action = toggle-window-floating;
      "Mod+Shift+P".action = pin-window;
      "Mod+F".action = maximize-column;
      "Mod+M".action = fullscreen-window;
    }
    // (import ./vimBinds.nix {inherit lib config;});
}
