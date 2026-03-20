{
  name = "gaming";

  nixos = {
    imports = [./controller.nix];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
  };
}
