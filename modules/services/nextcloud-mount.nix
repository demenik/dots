{lib, ...}: {
  name = "nextcloud-mount";
  moduleOptions = with lib; {
    nextcloud-mount.mountpoint = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = "Path to mount nextcloud to. Default: ~/Nextcloud";
    };
  };

  secrets.nextcloud-mount = {
    description = "rclone config for nextcloud";
    usedBy = "hm";
  };

  nixos = {
    programs.fuse.enable = true;
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    configFile = config.sops.secrets.nextcloud-mount.path;
    mountPoint =
      if config.nextcloud-mount.mountpoint != null
      then config.nextcloud-mount.mountpoint
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
          ExecStartPre = [
            "-/run/wrappers/bin/fusermount -u -z ${mountPoint}"
            "-${lib.getExe' pkgs.coreutils "mkdir"} -p ${mountPoint}"
          ];
          ExecStart = ''
            ${lib.getExe pkgs.rclone} mount nextcloud: ${mountPoint} \
              --config "${configFile}" \
              --vfs-cache-mode full \
              --vfs-cache-max-age 24h \
              --vfs-read-ahead 128M \
              --vfs-fast-fingerprint \
              --vfs-read-chunk-size 1M \
              --vfs-read-chunk-size-limit 10M \
              --transfers 4 \
              --dir-cache-time 8760h \
              --attr-timeout 8760h \
              --rc \
              --rc-no-auth \
              --rc-addr localhost:5572 \
              --allow-other=false \
              --volname "Nextcloud"
          '';
          ExecStartPost = [
            ''-${lib.getExe' pkgs.glib "gio"} set "${mountPoint}" metadata::custom-icon-name ${iconName}''
            ''-${lib.getExe pkgs.rclone} rc vfs/refresh recursive=true _async=true''
          ];
          ExecStop = "/run/wrappers/bin/fusermount -u -z ${mountPoint}";
          Restart = "always";
          RestartSec = "5s";
        };
        Install.WantedBy = ["default.target"];
      };

      timers.nextcloud-mount-refresh = {
        Unit.Description = "Refresh Nextcloud rclone cache";
        Timer = {
          OnBootSec = "2m";
          OnUnitActiveSec = "5m";
        };
        Install.WantedBy = ["timers.target"];
      };
      services.nextcloud-mount-refresh = {
        Unit.Description = "Refresh Nextcloud rclone cache";
        Service = {
          Type = "oneshot";
          ExecStart = "${lib.getExe pkgs.rclone} rc vfs/refresh recursive=true _async=true";
        };
      };
    };
  };
}
