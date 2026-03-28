{
  config,
  lib,
  ...
}:
with config.lib.niri.actions; let
  vimMap = rec {
    h = {
      dir = "l";
      x = -20;
      y = 0;
    };
    j = {
      dir = "d";
      x = 0;
      y = 20;
    };
    k = {
      dir = "u";
      x = 0;
      y = -20;
    };
    l = {
      dir = "r";
      x = 20;
      y = 0;
    };
    left = h;
    down = j;
    up = k;
    right = l;
  };
  keys = builtins.attrNames vimMap;

  focusBinds = builtins.listToAttrs (map (k: {
      name = "Mod+${k}";
      value.action = focus-column-or-monitor vimMap.${k}.dir;
    })
    keys);

  swapBinds = builtins.listToAttrs (map (k: {
      name = "Mod+Alt+${k}";
      value.action = move-column-or-monitor vimMap.${k}.dir;
    })
    keys);
in
  lib.mkMerge [
    # focusBinds
    # swapBinds
  ]
