{lib, ...}: {
  name = "nextcloud-mount";
  moduleOptions = with lib; {
    nextcloudMount.mountpoint = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to mount nextcloud to. Default: ~/Nextcloud";
    };
  };

  secrets.nextcloudMount = {
    description = "rclone config for nextcloud";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    configFile = config.sops.secrets.nextcloudMount.path;
    mountPoint =
      if config.nextcloudMount.mountpoint != null
      then config.nextcloudMount.mountpoint
      else "${config.home.homeDirectory}/Nextcloud";

    iconName = "nextcloud-mount";
  in {
    xdg.dataFile."icons/hicolor/scalable/apps/${iconName}.svg".source = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/nextcloud/desktop/refs/heads/master/theme/colored/Nextcloud-icon.svg";
      hash = "sha256-PAYCF1PxQOJu2tl2PpggunDNrSVHZgARF56O0b3oVG4=";
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
            -${lib.getExe' pkgs.glib "gio"} set "${mountPoint}" metadata::custom-icon-name ${iconName}
          '';
          ExecStop = "/run/wrappers/bin/fusermount -u -z ${mountPoint}";
          Restart = "always";
          RestartSec = "5s";
        };
        Install.WantedBy = ["default.target"];
      };
    };
  };
}
