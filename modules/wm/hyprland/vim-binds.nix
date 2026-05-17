{lib, ...}: let
  mkLua = lib.generators.mkLuaInline;

  vimMap = rec {
    h = {
      dir = "left";
      x = -20;
      y = 0;
    };
    j = {
      dir = "down";
      x = 0;
      y = 20;
    };
    k = {
      dir = "up";
      x = 0;
      y = -20;
    };
    l = {
      dir = "right";
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
  in {
    _args = [
      "${mod} + ${k}"
      (mkLua "hl.dsp.window.${cmd}({ x = ${toString v.x}, y = ${toString v.y} })")
    ];
  };
in
  # 1. focus + alter_zorder
  (map (k: {
      _args = [
        "SUPER + ${k}"
        (mkLua
          # lua
          ''
            function()
              hl.dispatch(hl.dsp.window.alter_zorder({ mode = 'top' }))
              hl.dispatch(hl.dsp.focus({ direction = '${vimMap.${k}.dir}' }))
            end
          '')
      ];
    })
    keys)
  # 2. swap
  ++ (map (k: {_args = ["SUPER + ALT + ${k}" (mkLua "hl.dsp.window.swap({ direction = '${vimMap.${k}.dir}' })")];}) keys)
  # 3. move
  ++ (map (mkPixelBind "SUPER + CTRL" "move") keys)
  # 4. resize
  ++ (map (mkPixelBind "SUPER + SHIFT" "resize") keys)
