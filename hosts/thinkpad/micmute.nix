{
  pkgs,
  lib,
  ...
}: {
  systemd.user.services.micmute-led = {
    Unit = {
      Description = "Sync micmute LED with actual state";
      After = ["graphical-session.target"];
    };
    Service = {
      Type = "simple";
      Restart = "on-failure";

      ExecStart = lib.getExe (pkgs.writeShellApplication {
        name = "micmute-led";
        runtimeInputs = with pkgs; [
          brightnessctl
          wireplumber
          uutils-coreutils-noprefix
          gnugrep
        ];
        text = ''
          LED="platform::micmute"

          sync_led() {
            if wpctl get-volume @DEFAULT_AUDIO_SOURCE@ | grep -q "MUTED"; then
              brightnessctl -d "$LED" set 1 || true
            else
              brightnessctl -d "$LED" set 0 || true
            fi
          }

          sync_led

          stdbuf -oL pw-mon -a | grep --line-buffered -A 2 "changed:" | while read -r line; do
            if echo "$line" | grep -q "PipeWire:Interface:Device"; then
              sync_led
            fi
          done
        '';
      });
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
