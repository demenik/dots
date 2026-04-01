{
  moduleConfig = {
    wm.monitors = [
      {
        output = "eDP-1";
        primary = true;
        mode = {
          width = 1920;
          height = 1200;
          refresh = 60.0;
        };
        position = {
          x = 0;
          y = 0;
        };
      }
    ];
  };

  nixosConfig = {
    config,
    lib,
    modulesPath,
    inputs,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-p14s-amd-gen5
    ];

    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "thunderbolt" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = ["kvm-amd"];
      kernelParams = [
        "amd_pstate=active"
        "amdgpu.sg_display=0"
        "amdgpu.abmlevel=3"
      ];
    };

    fileSystems = {
      "/" = {
        device = "/dev/disk/by-label/NIXROOT";
        fsType = "ext4";
      };
      "/boot" = {
        device = "/dev/disk/by-label/NIXBOOT";
        fsType = "vfat";
        options = ["fmask=0077" "dmask=0077"];
      };
    };

    swapDevices = [];

    networking.useDHCP = lib.mkDefault true;
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
