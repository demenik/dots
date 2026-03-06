{
  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;

      extraConfig.pipewire = {
        "99-allowed-rates" = {
          "context.properties" = {
            "default.clock.allowed-rates" = [44100 48000 88200 96000];
          };
        };
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          "99-audio-routing"."monitor.alsa.rules" = [
            # Momentum 4 Output
            {
              matches = [
                {"node.name" = "~.*MOMENTUM_4.*analog-stereo";}
              ];
              actions.update-props = {
                "priority.driver" = 1050;
                "priority.session" = 1050;
              };
            }

            # USB PnP Audio Device
            {
              matches = [
                {"node.name" = "~.*USB_PnP_Audio_Device.*";}
              ];
              actions.update-props = {
                "node.nick" = "USB Microphone";

                "priority.driver" = 1060;
                "priority.session" = 1060;
              };
            }

            # Momentum 4 Input
            {
              matches = [
                {"node.name" = "~.*MOMENTUM_4.*input.*";}
                {"node.name" = "~.*MOMENTUM_4.*mono.*";}
              ];
              actions.update-props = {
                "priority.driver" = 1050;
                "priority.session" = 1050;
              };
            }
          ];

          "99-hdmi-output"."monitor.alsa.rules" = [
            {
              matches = [
                {"node.name" = ".*.pro-output-8";}
              ];
              actions.update-props = {
                "node.nick" = "TV";

                "priority.driver" = 1040;
                "priority.session" = 1040;

                "channelmix.upmix" = true;
              };
            }
            {
              matches = [
                {"node.name" = "~.*.pro-output-[0-7]";}
                {"node.name" = "~.*.pro-output-9";}
              ];
              actions.update-props = {
                "node.disabled" = true;
              };
            }
          ];
        };
      };
    };

    # Don't autosuspend headphones
    udev.extraRules = ''
      ACTION=="add", SUBSYSTEM=="usb", TEST=="power/control", ATTR{idVendor}=="3542", ATTR{idProduct}=="1000", ATTR{power/control}="on"
    '';
    tlp.settings = {
      USB_DENYLIST = "3542:1000";
    };
  };
}
