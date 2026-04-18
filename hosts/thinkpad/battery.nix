{lib, ...}: {
  services = {
    upower.enable = true;
    power-profiles-daemon.enable = true;
    tlp.enable = lib.mkForce false;
  };
}
