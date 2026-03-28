{
  lib,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    monitorv2 = map (m: let
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
        else if m.vrr == false
        then 0
        else null;
    in
      lib.filterAttrs (n: v: v != null) {
        inherit (m) output scale bitdepth;

        mode =
          if m.mode != null
          then "${toString m.mode.width}x${toString m.mode.height}@${toString m.mode.refresh}"
          else null;

        position =
          if m.position != null
          then "${toString m.position.x}x${toString m.position.y}"
          else null;

        transform = transformVal;
        vrr = vrrVal;
        cm = m.colorMode;
      })
    config.wm.monitors;

    windowrule = map (rule: let
      ruleName = "rule-${
        if rule.matchClass != null
        then rule.matchClass
        else "any"
      }-${
        if rule.matchTitle != null
        then "with-title"
        else "any"
      }";
    in
      lib.filterAttrs (n: v: v != null) {
        name = ruleName;

        "match:class" =
          if rule.matchClass != null
          then "^(${rule.matchClass})$"
          else null;
        "match:title" =
          if rule.matchTitle != null
          then "^(${rule.matchTitle})$"
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
        opacity =
          if rule.opacity != null
          then toString rule.opacity
          else null;
        no_initial_focus = rule.noInitialFocus;
        keep_aspect_ratio = rule.keepAspectRatio;
        pin = rule.pinned;
      })
    config.wm.windowrules;

    bind = map (bind: let
      mods = builtins.concatStringsSep " " bind.modifiers;

      action =
        if bind.exec != null
        then "exec, ${bind.exec}"
        else "exec, echo 'No action'";
    in "${mods}, ${bind.key}, ${action}")
    config.wm.binds;
  };
}
