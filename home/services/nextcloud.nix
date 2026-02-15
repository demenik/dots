{
  pkgs,
  config,
  lib,
  ...
}: let
  configFile = config.age.secrets.nextcloud.path;
  mountPoint = "${config.home.homeDirectory}/Nextcloud";

  iconName = "nextcloud-mount";
  iconPath = "${config.home.homeDirectory}/.local/share/icons/hicolor/scalable/apps/${iconName}.svg";
in {
  xdg.dataFile = {
    "icons/hicolor/scalable/apps/${iconName}.svg".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nextcloud/desktop/refs/heads/master/theme/colored/Nextcloud-icon.svg";
      hash = "sha256-PAYCF1PxQOJu2tl2PpggunDNrSVHZgARF56O0b3oVG4=";
    };
    "icons/hicolor/symbolic/apps/${iconName}-symbolic.svg".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nextcloud/desktop/refs/heads/master/theme/white/wizard-nextcloud.svg";
      hash = "sha256-n1l3GVpQNnmZgrcwhWchvw8MsAmolzjxkYpJIw90PFc=";
    };
  };

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
            --allow-other=false \
            --volname "Nextcloud"
        '';
        ExecStartPost = ''
          ${lib.getExe' pkgs.glib "gio"} set "${mountPoint}" metadata::custom-icon-name ${iconName}
        '';
        ExecStop = "/run/wrappers/bin/fusermount -u -z ${mountPoint}";
        Restart = "always";
        RestartSec = "5s";
      };
      Install.WantedBy = ["default.target"];
    };
  };
}
