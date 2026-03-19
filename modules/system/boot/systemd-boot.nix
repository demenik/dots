{
  name = "systemd-boot";

  nixos = {
    boot = {
      loader.efi.canTouchEfiVariables = true;
      loader.systemd-boot.enable = true;
    };
  };
}
