{
  modules = [
    ../../modules/services/pipewire.nix
  ];
  moduleConfig = {
    pipewire.devices = {
      "~.*MOMENTUM_4.*analog-stereo" = {
        alias = "Momentum 4 Stereo";
        priority = 1050;
      };
      "~.*MOMENTUM_4.*mono.*" = {
        alias = "Momentum 4 Mono";
        priority = 1040;
      };
      "~.*MOMENTUM_4.*input.*" = {
        alias = "Momentum 4 Input";
        priority = 1040;
      };

      "~.*USB_PnP_Audio_Device.*" = {
        alias = "USB Microphone";
        priority = 1050;
      };

      ".*.pro-output-8" = {
        alias = "TV";
        priority = 1030;
      };
      "~.*.pro-output-[0-7]".enable = false;
      "~.*.pro-output-9".enable = false;
    };
  };
}
