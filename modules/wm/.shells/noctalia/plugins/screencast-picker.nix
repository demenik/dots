{
  pkgs,
  lib,
  config,
  ...
}:
lib.mkIf (config.services ? xdph) {
  programs.noctalia-shell.plugins = {
    states."563115:screencast-picker" = {
      enabled = true;
      sourceUrl = "https://github.com/demenik/noctalia-v4-plugins";
    };
  };

  services.xdph.settings = {
    screencopy.customPickerBinary = "${config.xdg.configHome}/noctalia/plugins/563115:screencast-picker/scripts/pick.sh";
  };

  systemd.user.services.hyprland-screencast-monitor = {
    Unit = {
      Description = "Monitor Hyprland IPC for screencast events to toggle DND";
      PartOf = ["graphical-session.target"];
      After = ["graphical-session.target"];
    };
    Service = {
      ExecStart = lib.getExe (pkgs.writeShellScriptBin "hyprland-screencast-monitor" ''
        if [ -z "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
          echo "Error: HYPRLAND_INSTANCE_SIGNATURE is not set."
          exit 1
        fi

        TIMER_PID=""

        socat -U - UNIX-CONNECT:"$XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/.socket2.sock" | while read -r line; do
          if [[ "$line" == "screencast>>1,"* ]]; then
            if [ -n "$TIMER_PID" ] && kill -0 "$TIMER_PID" 2>/dev/null; then
              kill "$TIMER_PID"
              echo "Screencast restarted within delay period. Cancelled DND disable timer."
            else
              echo "Screencast started. Enabling DND..."
              noctalia-shell ipc call notifications enableDND
            fi
            TIMER_PID=""

          elif [[ "$line" == "screencast>>0,"* ]]; then
            (
              sleep 4
              echo "Screencast stopped for good. Disabling DND..."
              noctalia-shell ipc call notifications disableDND
            ) &

            TIMER_PID=$!
          fi
        done
      '');
      Restart = "always";
      RestartSec = "3";
      Environment = "PATH=${lib.makeBinPath [
        pkgs.socat
        pkgs.coreutils
        config.programs.noctalia-shell.package
      ]}";
    };
    Install.WantedBy = ["hyprland-session.target"];
  };
}
