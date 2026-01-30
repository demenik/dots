{
  pkgs,
  lib,
  ...
}: {
  services = {
    power-profiles-daemon.enable = false;
    tlp.enable = lib.mkForce false;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
  };

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      rocmPackages.clr.icd
    ];
  };

  powerManagement.powertop.enable = true;
}
