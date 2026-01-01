{
  config,
  lib,
  modulesPath,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot = {
    initrd.availableKernelModules = ["nvme" "xhci_pci" "ahci" "usbhid" "sd_mod"];
    kernelModules = ["kvm-amd" "it87"];

    extraModulePackages = [config.boot.kernelPackages.it87];
    kernelParams = ["acpi_enforce_resources=lax" "amdgpu.ppfeaturemask=0xffffffff"];
    extraModprobeConfig = ''
      options it87 force_id=0x8628 ignore_resource_conflict=1
    '';
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

    "/mnt/M.2" = {
      device = "/dev/disk/by-label/M.2";
      fsType = "ntfs3";
      options = ["rw" "uid=1000" "gid=100" "nofail" "user" "x-systemd.automount" "x-gvfs-show"];
    };
    "/mnt/SSD" = {
      device = "/dev/disk/by-label/SSD";
      fsType = "ntfs3";
      options = ["rw" "uid=1000" "gid=100" "nofail" "user" "x-systemd.automount" "x-gvfs-show"];
    };
  };

  swapDevices = [];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
