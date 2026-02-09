{lib, ...}: {
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

  powerManagement.powertop.enable = true;
}
