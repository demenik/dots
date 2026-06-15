{
  modules = [../../modules/system/ntfs.nix];
  moduleConfig = {
    wm.monitors = [
      {
        output = "HDMI-A-1";
        primary = true;
        mode = {
          width = 1920;
          height = 1080;
          refresh = 143.98;
        };
        position = {
          x = 0;
          y = 0;
        };
        scale = 1;
      }
      {
        output = "DP-1";
        mode = {
          width = 1920;
          height = 1080;
          refresh = 60.0;
        };
        position = {
          x = 1920;
          y = 0;
        };
        scale = 1;
        transform.rotation = 90;
      }
      {
        output = "HDMI-A-2";
        mode = {
          width = 4096;
          height = 2160;
          refresh = 120.0;
        };
        position = {
          x = -4096;
          y = 0;
        };
        scale = 2;
        bitdepth = 10;
        colorMode = "hdr";
        vrr = true;
      }
    ];
  };

  homeConfig = {
    wayland.windowManager.hyprland.settings.workspace_rule =
      [
        {
          workspace = "1";
          monitor = "HDMI-A-1";
          default = true;
          persistent = true;
        }
        {
          workspace = "2";
          monitor = "DP-1";
          default = true;
          persistent = true;
        }
        {
          workspace = "3";
          monitor = "DP-1";
        }
        {
          workspace = "m[DP-1]";
          layout_opts.orientation = "top";
        }
        {
          workspace = "10";
          monitor = "HDMI-A-2";
          default = true;
          persistent = true;
        }
      ]
      ++ map (i: {
        workspace = toString i;
        monitor = "HDMI-A-1";
      }) [4 5 6 7 8 9];
  };

  nixosConfig = {
    config,
    lib,
    modulesPath,
    ...
  }: {
    imports = [
      (modulesPath + "/installer/scan/not-detected.nix")
      ./fans.nix
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

      "/mnt/WINDOWS" = {
        device = "/dev/disk/by-label/WINDOWS";
        fsType = "ntfs3";
        options = ["rw" "uid=1000" "gid=100" "nofail" "user" "x-systemd.automount" "x-gvfs-show"];
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
