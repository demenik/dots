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

          serviceConfig.Type = "oneshot";

          path = [pkgs.liquidctl pkgs.coreutils];

          script = ''
            for _ in $(seq 30); do
              if liquidctl --match "Commander Pro" initialize --direct-access --fan-mode "${fanModeArg}"; then
                exit 0
              fi
              sleep 1
            done
            exit 1
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
