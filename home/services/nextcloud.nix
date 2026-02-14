{
  pkgs,
  config,
  lib,
  ...
}: let
  configFile = config.age.secrets.nextcloud.path;
  mountPoint = "${config.home.homeDirectory}/Nextcloud";

  ncIcon = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/nextcloud/promo/master/nextcloud-icon.svg";
    hash = "sha256-wqzR2retViX/kGuAkG+7doZrvfj0TAAvFVSOygqr8Fs=";
  };
in {
  systemd.user = {
    services.nextcloud-mount = {
      Unit = {
        Description = "Mount Nextcloud";
        After = ["network-online.target"];
        Wants = ["network-online.target"];
      };

      Service = {
        Type = "notify";
        ExecStartPre = "${lib.getExe' pkgs.uutils-coreutils-noprefix "mkdir"} -p ${mountPoint}";
        ExecStart = ''
          ${lib.getExe pkgs.rclone} mount nextcloud: ${mountPoint} \
            --config "${configFile}" \
            --vfs-cache-mode full \
            --vfs-cache-max-age 24h \
            --dir-cache-time 5m \
            --allow-other=false
        '';
        ExecStartPost = ''
          ${lib.getExe' pkgs.glib "gio"} set "${mountPoint}" metadata::custom-icon-name "${ncIcon}"
        '';
        ExecStop = "/run/wrappers/bin/fusermount -u -z ${mountPoint}";
        Restart = "on-failure";
        RestartSec = "10s";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
