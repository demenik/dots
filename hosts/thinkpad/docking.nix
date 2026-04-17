{
  pkgs,
  lib,
  config,
  ...
}: let
  monitorSwitch = pkgs.writeShellApplication {
    name = "hypr-monitor-switch";
    runtimeInputs = with pkgs; [
      hyprland
      jq
    ];
    text = ''
      INTERNAL="eDP-1"
      EXTERNAL="HDMI-A-1"

      if hyprctl monitors | grep -q "$EXTERNAL"; then
        TARGET="$EXTERNAL"
        hyprctl dispatch dpms off "$INTERNAL"
      else
        TARGET="$INTERNAL"
        hyprctl dispatch dpms on "$INTERNAL"
      fi

      for i in {1..10}; do
        hyprctl keyword workspace "$i, monitor:$TARGET"
      done

      hyprctl workspaces -j | jq -r '.[] | .id' | while read -r ws; do
        hyprctl dispatch moveworkspacetomonitor "$ws" "$TARGET"
      done
    '';
  };

  monitorListener = pkgs.writeShellApplication {
    name = "hypr-monitor-listener";
    runtimeInputs = with pkgs; [
      socat
      monitorSwitch
    ];
    text = ''
      socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR"/hypr/"$HYPRLAND_INSTANCE_SIGNATURE"/.socket2.sock | while read -r line; do
        if echo "$line" | grep -q "monitoradded\|monitorremoved"; then
          hypr-monitor-switch
        fi
      done
    '';
  };
in {
  home.packages = [
    monitorSwitch
  ];

  wayland.windowManager.hyprland.settings = lib.mkIf config.wayland.windowManager.hyprland.enable {
    exec-once = [
      (lib.getExe monitorSwitch)
      (lib.getExe monitorListener)
    ];
  };
}
