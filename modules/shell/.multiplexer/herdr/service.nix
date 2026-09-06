{
  lib,
  config,
  ...
}: let
  inherit (lib) mkEnableOption mkIf getExe;
  cfg = config.programs.herdr;
in {
  options.programs.herdr.service.enable = mkEnableOption ''
    a persistent user-level `herdr server`. Meant for headless hosts so
    herdr-mirror clients can attach without an interactive login session.
    Requires user lingering to survive logout/reboot
  '';

  config = mkIf (cfg.enable && cfg.service.enable) {
    systemd.user.services.herdr-server = {
      Unit.Description = "Headless herdr server";
      Install.WantedBy = ["default.target"];
      Service = {
        ExecStart = "${getExe cfg.package} server";
        ExecStop = "${getExe cfg.package} server stop";
        Restart = "on-failure";
        RestartSec = 5;
      };
    };
  };
}
