{lib, ...}: {
  name = "pipewire";
  moduleOptions = with lib; {
    pipewire.devices = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          enable = mkOption {
            type = types.bool;
            default = true;
            description = "Wether to enable this device";
          };
          alias = mkOption {
            type = types.nullOr types.str;
            default = null;
            description = "Alias to assign to the device";
          };
          priority = mkOption {
            type = types.nullOr types.int;
            default = null;
            description = "Priority of the device";
          };
        };
      });
      default = [];
      description = "List of audio devices. Key should be node.name of the device.";
    };
  };

  nixos = {
    lib,
    config,
    ...
  }: {
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire = {
        "99-allowed-rates"."context.properties" = {
          "default.clock.allowed-rates" = [44100 48000 88200 96000];
        };
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          "99-auto-generated"."monitor.alsa.rules" =
            lib.mapAttrsToList (nodeName: dev: {
              matches = [{"node.name" = nodeName;}];
              actions.update-props = lib.filterAttrs (n: v: v != null) {
                "node.disabled" = !dev.enable;
                "node.description" = dev.alias;
                "priority.session" = dev.priority;
                "priority.driver" = dev.priority;
              };
            })
            config.pipewire.devices;
        };
      };
    };
  };
}
