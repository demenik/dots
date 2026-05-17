{
  lib,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = let
    mkLua = lib.generators.mkLuaInline;
  in {
    monitor =
      map (m: let
        transformVal =
          if m.transform != null
          then let
            rot =
              {
                "0" = 0;
                "90" = 1;
                "180" = 2;
                "270" = 3;
              }.${
                toString m.transform.rotation
              };
          in
            if m.transform.flipped
            then rot + 4
            else rot
          else null;

        vrrVal =
          if m.vrr == true
          then 1
          else if m.vrr == "on-demand"
          then 2
          else 0;
      in {
        inherit (m) output;
        mode = "${toString m.mode.width}x${toString m.mode.height}@${toString m.mode.refresh}";
        position = "${toString m.position.x}x${toString m.position.y}";
        scale = m.scale;
        transform = transformVal;
        vrr = vrrVal;
        bitdepth =
          if m.bitdepth != null
          then m.bitdepth
          else 8;
      })
      config.wm.monitors;

    window_rule = map (rule: let
      match = lib.filterAttrs (n: v: v != null) {
        class =
          if rule.matchClass != null
          then "^(${rule.matchClass})$"
          else null;
        title =
          if rule.matchTitle != null
          then "^(${rule.matchTitle})$"
          else null;
      };
    in
      lib.filterAttrs (n: v: v != null) {
        name = "rule-${
          if rule.matchClass != null
          then rule.matchClass
          else "any"
        }-${
          if rule.matchTitle != null
          then "with-title"
          else "any"
        }";
        match =
          if match != {}
          then match
          else null;

        inherit (rule) workspace monitor center fullscreen;
        float = rule.floating;
        size =
          if rule.size != null
          then "${toString (builtins.elemAt rule.size 0)} ${toString (builtins.elemAt rule.size 1)}"
          else null;
        move =
          if rule.position != null
          then "${builtins.elemAt rule.position 0} ${builtins.elemAt rule.position 1}"
          else null;
        inherit (rule) opacity;
        no_initial_focus = rule.noInitialFocus;
        keep_aspect_ratio = rule.keepAspectRatio;
        pin = rule.pinned;
      })
    config.wm.windowrules;

    bind = map (bind: let
      mods = builtins.concatStringsSep " + " bind.modifiers;
      combo =
        if mods == ""
        then bind.key
        else "${mods} + ${bind.key}";
      action =
        if bind.exec != null
        then "hl.dsp.exec_cmd(\"${bind.exec}\")"
        else "hl.dsp.exec_cmd(\"echo 'No action'\")";
    in {_args = [combo (mkLua action)];})
    config.wm.binds;
  };
}
