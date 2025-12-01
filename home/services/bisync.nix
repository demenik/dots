{
  config,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [rclone];

  systemd.user = let
    mkBiSync = {
      name,
      ageName,
      localDir,
      remoteDir,
    }: {
      services."sync-${name}" = {
        Unit = {
          Description = "Rclone bi-directional ${name} syncing";
          After = ["network-online.target"];
        };
        Service = {
          EnvironmentFile = "%t/agenix/${ageName}";
          ExecStart = ''
            ${pkgs.lib.getExe pkgs.rclone} bisync \
              "${localDir}" \
              "NEXTCLOUD:${remoteDir}" \
              --resync \
              --verbose
          '';
        };
      };

      paths."sync-${name}" = {
        Unit.Description = "Rclone bi-directional ${name} syncing watch path";
        Path = {
          PathChanged = localDir;
          PathModified = localDir;
        };
        Install.WantedBy = ["default.target"];
      };

      timers."sync-${name}" = {
        Unit.Description = "Rclone bi-directional ${name} syncing timer";
        Timer = {
          OnBootSec = "5min";
          OnUnitActiveSec = "1h";
          Unit = "sync-${name}.service";
        };
        Install.WantedBy = ["timers.target"];
      };
    };

    combine = builtins.foldl' (acc: set: acc // set) {};
  in
    combine [
      (mkBiSync {
        name = "music";
        ageName = "nextcloud";
        localDir = "${config.home.homeDirectory}/Music/";
        remoteDir = "Musik";
      })
    ];
}
