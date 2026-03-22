{lib, ...}: {
  name = "wallpaper-engine";
  moduleOptions = with lib; {
    wallpaperEngine = {
      monitors = mkOption {
        type = types.listOf types.str;
        default = ["eDP-1" "HDMI-A-1" "HDMI-A-2" "DP-1"];
        description = "List of all monitors to apply wallpapers to";
      };

      wallpapers = mkOption {
        type = types.attrsOf (types.submodule {
          options = {
            wallpaperId = mkOption {
              type = types.nullOr types.str;
              default = null;
              example = "1200920610";
              description = "Steam workshop ID of the wallpaper. These can be found at ~/.steam/steam/steamapps/workshop/content/431960";
            };
            scaling = mkOption {
              type = types.nullOr (types.enum ["stretch" "fit" "fill" "default"]);
              default = null;
            };
            fps = mkOption {
              type = types.nullOr types.int;
              default = null;
            };
            extraOptions = mkOption {
              type = types.nullOr (types.listOf types.str);
              default = null;
            };

            audio = {
              silent = mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
              processing = mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
              automute = mkOption {
                type = types.nullOr types.bool;
                default = null;
              };
            };
          };
        });
        default = {};
        example = {
          "*" = {
            wallpaperId = 1200920610;
            scaling = "fill";
          };
          "DP-1".wallpaperId = 2845358245;
        };
        description = "Configure wallpapers per monitor. Wildcard are possible (uses wallpaperEngine.monitors)";
      };
    };
  };

  home = {
    lib,
    config,
    ...
  }: {
    services.linux-wallpaperengine = {
      enable = true;
      wallpapers = let
        cfg = config.wallpaperEngine;
        global = cfg.wallpapers."*" or {};

        getOpt = obj: prop:
          if obj.${prop} != null
          then obj.${prop}
          else if (global ? ${prop}) && global.${prop} != null
          then global.${prop}
          else null;

        getAudioOpt = obj: prop:
          if obj.audio.${prop} != null
          then obj.audio.${prop}
          else if (global ? audio) && global.audio.${prop} != null
          then global.audio.${prop}
          else null;

        targetMonitors =
          if builtins.hasAttr "*" cfg.wallpapers
          then cfg.monitors
          else builtins.attrNames (removeAttrs cfg.wallpapers ["*"]);
      in
        map (
          monitor: let
            specific =
              cfg.wallpapers.${
                monitor
              } or {
                wallpaperId = null;
                scaling = null;
                fps = null;
                extraOptions = null;
                audio = {
                  silent = null;
                  processing = null;
                  automute = null;
                };
              };

            baseOpts = lib.filterAttrs (k: v: v != null) {
              inherit monitor;
              wallpaperId = getOpt specific "wallpaperId";
              scaling = getOpt specific "scaling";
              fps = getOpt specific "fps";
              extraOptions = getOpt specific "extraOptions";
            };
            audioOpts = lib.filterAttrs (k: v: v != null) {
              silent = getAudioOpt specific "silent";
              processing = getAudioOpt specific "processing";
              automute = getAudioOpt specific "automute";
            };
          in
            if audioOpts == {}
            then baseOpts
            else baseOpts // {audio = audioOpts;}
        )
        targetMonitors;
    };

    systemd.user.services.linux-wallpaperengine.Service = {
      Environment = ["XDG_SESSION_TYPE=wayland"];
      Restart = "on-failure";
      RestartSec = "1";
    };
  };

  nixos = {
    pkgs,
    lib,
    users,
    ...
  }: let
    resumeScripts =
      map
      (u: "${lib.getExe' pkgs.systemd "systemctl"} --user -M ${u.username}@ restart linux-wallpaperengine.service")
      users;
  in {
    powerManagement.resumeCommands = lib.concatStringsSep "\n" resumeScripts;
  };
}
