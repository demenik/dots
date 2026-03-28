{
  lib,
  config,
  ...
}: {
  programs.niri.settings = {
    outputs = lib.listToAttrs (
      map (m:
        lib.nameValuePair m.output (lib.filterAttrs (n: v: v != null) {
          inherit (m) scale transform;

          mode =
            if m.mode != null
            then {
              inherit (m.mode) width height refresh;
            }
            else null;

          position =
            if m.position != null
            then {
              inherit (m.position) x y;
            }
            else null;

          variable-refresh-rate = m.vrr;
        }))
      config.wm.monitors
    );

    window-rules = map (rule:
      {
        matches = [
          (lib.filterAttrs (n: v: v != null) {
            app-id =
              if rule.matchClass != null
              then "^(${rule.matchClass})$"
              else null;
            title =
              if rule.matchTitle != null
              then "^(${rule.matchTitle})$"
              else null;
          })
        ];
      }
      // (lib.filterAttrs (n: v: v != null) {
        open-on-workspace = rule.workspace;
        open-on-output = rule.monitor;
        open-fullscreen = rule.fullscreen;
        open-floating = rule.floating;
        inherit (rule) opacity;
      }))
    config.wm.windowrules;

    binds = lib.listToAttrs (map (bind: let
      bindStr = builtins.concatStringsSep "+" (bind.modifiers ++ [bind.key]);
      action = with config.lib.niri.actions;
        if bind.exec != null
        then spawn ["sh" "-c" bind.exec]
        else spawn ["sh" "-c" "echo 'No Action'"];
    in
      lib.nameValuePair bindStr {
        inherit action;
      })
    config.wm.binds);
  };
}
