{
  lib,
  config,
  ...
}: {
  wayland.windowManager.hyprland.settings = {
    monitorv2 =
      map (m: {
        inherit (m) output mode position scale transform bitdepth vrr;
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
