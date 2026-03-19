let
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

  mkPixelBind = mod: cmd: k: let
    v = vimMap.${k};
  in "${mod}, ${k}, ${cmd}, ${toString v.x} ${toString v.y}";
in
  # 1. movefocus + bringactivetotop
  (map (k: "SUPER, ${k}, bringactivetotop") keys)
  ++ (map (k: "SUPER, ${k}, movefocus, ${vimMap.${k}.dir}") keys)
  # 2. swapwindow
  ++ (map (k: "SUPER ALT, ${k}, swapwindow, ${vimMap.${k}.dir}") keys)
  # 3. moveactive
  ++ (map (mkPixelBind "SUPER CTRL" "moveactive") keys)
  # 4. resizeactive
  ++ (map (mkPixelBind "SUPER SHIFT" "resizeactive") keys)
