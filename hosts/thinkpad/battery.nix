{
  pkgs,
  lib,
  ...
}: {
  services = {
    upower.enable = true;
    power-profiles-daemon.enable = true;
    tlp.enable = lib.mkForce false;
  };

  systemd.services.power-saver-default = {
    description = "Enforce power-saver profile for power-profiles-daemon";
    wantedBy = ["multi-user.target"];
    after = ["power-profiles-daemon.service"];
    requires = ["power-profiles-daemon.service"];

    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${lib.getExe pkgs.power-profiles-daemon} set power-saver";
      RemainAfterExit = "yes";
    };
  };
}
