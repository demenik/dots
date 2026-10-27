{lib, ...}: {
  name = "bluetooth-autoconnect";

  modules = [
    ./bluetooth.nix
  ];

  moduleOptions = with lib; {
    bluetooth-autoconnect.interval = mkOption {
      type = types.ints.positive;
      default = 30;
      description = "Seconds between connection attempts to disconnected devices";
    };
  };

  secrets.devices = {
    usedBy = "nixos";
    description = "Newline-separated MAC addresses of paired devices to keep connected";
  };

  nixos = {
    pkgs,
    lib,
    config,
    ...
  }: let
    bluetoothctl = lib.getExe' pkgs.bluez "bluetoothctl";
    devicesFile = config.sops.secrets."bluetooth-autoconnect/devices".path;
  in {
    systemd.services.bluetooth-autoconnect = {
      description = "Keep trusted Bluetooth devices connected";
      after = ["bluetooth.service"];
      bindsTo = ["bluetooth.service"];
      wantedBy = ["bluetooth.service"];

      serviceConfig = {
        Restart = "always";
        RestartSec = 10;
      };

      path = [pkgs.gnugrep pkgs.coreutils];

      script = ''
        mapfile -t devices < <(grep -oiE '([0-9a-f]{2}:){5}[0-9a-f]{2}' ${devicesFile})

        for mac in "''${devices[@]}"; do
          ${bluetoothctl} trust "$mac" >/dev/null || true
        done

        while true; do
          if ${bluetoothctl} show | grep -q "Powered: yes"; then
            for mac in "''${devices[@]}"; do
              if ! ${bluetoothctl} info "$mac" | grep -q "Connected: yes"; then
                timeout 15 ${bluetoothctl} connect "$mac" >/dev/null 2>&1 || true
              fi
            done
          fi
          sleep ${toString config.bluetooth-autoconnect.interval}
        done
      '';
    };
  };
}
