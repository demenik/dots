{
  modules = [../../modules/ntfs.nix];
  moduleConfig = {
    wm.monitors = [
      {
        output = "HDMI-A-1";
        mode = "1920x1080@143.98";
        position = "0x0";
        scale = 1;
      }
      {
        output = "DP-1";
        mode = "1920x1080@60";
        position = "1920x0";
        scale = 1;
      }
      {
        output = "HDMI-A-2";
        mode = "4096x2160@120";
        position = "-4096x0";
        scale = 2;
        bitdepth = 10;
        colorMode = "hdr";
        vrr = 1;
      }
    ];
  };

  nixosConfig = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

    boot = {
      initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usb_storage" "usbhid" "sd_mod"];
      kernelModules = ["kvm-amd"];
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

      "/mnt/SSD" = {
        device = "/dev/disk/by-label/SSD";
        fsType = "ntfs3";
        options = ["rw" "uid=1000" "gid=100" "nofail" "user" "x-systemd.automount" "x-gvfs-show"];
      };
    };

    swapDevices = [{device = "/dev/disk/by-label/SWAP";}];

    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
    hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  };
}
