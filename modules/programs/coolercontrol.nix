{lib, ...}: {
  name = "coolercontrol";

  moduleOptions = with lib; {
    coolercontrol.commanderPro.fanModes = mkOption {
      type = types.attrsOf (types.enum ["pwm" "dc" "off"]);
      default = {};
      example = {
        "1" = "pwm";
        "2" = "dc";
      };
      description = ''
        Fan port modes forced on a Corsair Commander Pro, keyed by port number.
        The device forgets modes set by iCUE on power loss and its auto-detection
        can fail, leaving fans uncontrollable at full speed.
      '';
    };
  };

  nixos = {
    pkgs,
    lib,
    config,
    ...
  }: let
    fanModes = config.coolercontrol.commanderPro.fanModes;
    fanModeArg = lib.concatStringsSep "," (lib.mapAttrsToList (port: mode: "${port}:${mode}") fanModes);
    resumeTargets = ["suspend.target" "hibernate.target" "hybrid-sleep.target" "suspend-then-hibernate.target"];
  in
    lib.mkMerge [
      {programs.coolercontrol.enable = true;}

      (lib.mkIf (fanModes != {}) {
        systemd.services.commander-pro-fan-modes = {
          description = "Set Corsair Commander Pro fan port modes";
          before = ["coolercontrold.service"];
          after = resumeTargets;
          wantedBy = ["multi-user.target"] ++ resumeTargets;

          restartIfChanged = false;
          serviceConfig.Type = "oneshot";

          path = [pkgs.liquidctl pkgs.coreutils pkgs.systemd];

          script = ''
            daemon_active=false
            if systemctl is-active --quiet coolercontrold.service; then
              daemon_active=true
              systemctl stop coolercontrold.service
            fi

            ok=false
            for _ in $(seq 30); do
              if liquidctl --match "Commander Pro" initialize --direct-access --fan-mode "${fanModeArg}"; then
                ok=true
                break
              fi
              sleep 1
            done

            for dev in /sys/bus/hid/drivers/corsair-cpro/0003:1B1C:0C10.*; do
              [ -e "$dev" ] || continue
              name=$(basename "$dev")
              echo "$name" >/sys/bus/hid/drivers/corsair-cpro/unbind
              echo "$name" >/sys/bus/hid/drivers/corsair-cpro/bind
            done

            if $daemon_active; then
              systemctl start --no-block coolercontrold.service
            fi

            $ok
          '';
        };
      })
    ];

  hostInstructions = ''
    Install coolercontrol on host system
  '';

  home = {pkgs, ...}: {
    home.packages = with pkgs; [
      openrgb-with-all-plugins
      coolercontrol.coolercontrol-gui
    ];
  };
}
