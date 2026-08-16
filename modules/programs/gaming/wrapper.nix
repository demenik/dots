{lib, ...}: let
  inherit (lib) mkOption types;

  gamescopeArgType = types.nullOr (types.oneOf [types.bool types.int types.str]);

  gameSubmodule = types.submodule {
    options = {
      gamescope = {
        enable = mkOption {
          type = types.nullOr types.bool;
          default = null;
          description = "Whether to wrap this game with gamescope. Defaults to `programs.gaming.wrapper.defaults.gamescope.enable` when null.";
        };
        args = mkOption {
          type = types.attrsOf gamescopeArgType;
          default = {};
          description = "Gamescope arguments for this game, merged over `programs.gaming.wrapper.defaults.gamescope.args` (set a key to null to unset an inherited default).";
        };
      };

      gamemode.enable = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Whether to wrap this game with gamemoderun. Defaults to `programs.gaming.wrapper.defaults.gamemode.enable` when null.";
      };

      mangohud.enable = mkOption {
        type = types.nullOr types.bool;
        default = null;
        description = "Whether to show the MangoHud overlay for this game (via gamescope's mangoapp when gamescope is used, or the MANGOHUD env var otherwise). Defaults to `programs.gaming.wrapper.defaults.mangohud.enable` when null.";
      };

      env = mkOption {
        type = types.attrsOf (types.nullOr types.str);
        default = {};
        description = "Extra environment variables for this game, merged over `programs.gaming.wrapper.defaults.env` (set a key to null to unset an inherited default).";
      };

      extraArgs = mkOption {
        type = types.listOf types.str;
        default = [];
        description = "Extra CLI arguments appended after the game's own arguments, in addition to `programs.gaming.wrapper.defaults.extraArgs`.";
      };
    };
  };
in {
  moduleOptions = {
    programs.gaming.wrapper = {
      defaults = {
        gamescope = {
          enable = mkOption {
            type = types.bool;
            default = false;
            description = "Whether games wrap with gamescope by default when not overridden per-game.";
          };
          args = mkOption {
            type = types.attrsOf gamescopeArgType;
            default = {};
            description = "Default gamescope arguments, merged under each game's `gamescope.args`.";
          };
        };

        gamemode.enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether games wrap with gamemoderun by default when not overridden per-game.";
        };

        mangohud.enable = mkOption {
          type = types.bool;
          default = false;
          description = "Whether to show the MangoHud overlay by default when not overridden per-game (via gamescope's mangoapp when gamescope is used, or the MANGOHUD env var otherwise).";
        };

        env = mkOption {
          type = types.attrsOf types.str;
          default = {};
          description = "Default extra environment variables, merged under each game's `env`.";
        };

        extraArgs = mkOption {
          type = types.listOf types.str;
          default = [];
          description = "Default extra CLI arguments, prepended before each game's `extraArgs`.";
        };
      };

      games = mkOption {
        type = types.attrsOf gameSubmodule;
        default = {};
        description = ''
          Per-game gamescope/gamemode wrapper configuration, keyed by an
          arbitrary game identifier (e.g. "steam:<appid>" or "osu").
        '';
        example = lib.literalExpression ''
          {
            "steam:1091500" = {
              gamescope.enable = true;
              gamescope.args = { fullscreen = true; W = 2560; H = 1440; };
              gamemode.enable = true;
            };
            osu.gamemode.enable = true;
          }
        '';
      };

      script = mkOption {
        type = types.package;
        readOnly = true;
        description = ''
          `game-wrapper <game-id> [--] <command> [args...]` script that looks up
          the wrapper config for `<game-id>` in `programs.gaming.wrapper.games`
          (falling back to `programs.gaming.wrapper.defaults`) and execs
          `<command>` through gamescope and/or gamemoderun accordingly. Not
          installed on PATH; consume it via this option.
        '';
      };

      wrapPackage = mkOption {
        type = types.functionTo (types.functionTo types.package);
        readOnly = true;
        description = ''
          `wrapPackage game-id pkg` wraps `pkg`'s main program, so it launches
          through gamescope and/or gamemoderun according to the
          `programs.gaming.wrapper.games.<game-id>` configuration.
        '';
      };

      exposeOnPath = mkOption {
        type = types.functionTo types.package;
        readOnly = true;
        description = ''
          `exposeOnPath pkg` patches `pkg`'s main program so `game-wrapper` (and
          gamescope/gamemode transitively) is on `$PATH` when it runs, without
          changing what it actually executes. Useful for packages that launch
          games themselves and need `game-wrapper` reachable by name (e.g. from
          a Steam launch-option field or a plugin), rather than being wrapped
          into an exec chain like `wrapPackage` does. Note this only works for
          plain wrapped binaries; it will not reach into a package's own
          sandbox (e.g. a `buildFHSEnv`-based package like `steam` needs its
          own `extraPkgs` mechanism instead).
        '';
      };
    };
  };

  moduleConfig = {
    pkgs,
    lib,
    config,
    ...
  }:
    with lib; let
      cfg = config.programs.gaming.wrapper;

      # Converts a gamescope arg set (e.g. `{ fullscreen = true; W = 1920; }`)
      # into CLI flags (`--fullscreen -W 1920`). Single-character names get a
      # single dash, longer names a double dash; `null` values are dropped
      # (used to unset an inherited default flag) and `false` values are
      # omitted.
      mkFlags = args: let
        present = filterAttrs (_: v: v != null) args;
      in
        concatMap (
          name: let
            value = present.${name};
            flag =
              if stringLength name == 1
              then "-${name}"
              else "--${name}";
          in
            if isBool value
            then optional value flag
            else [flag (toString value)]
        ) (attrNames present);

      mkEnvArgs = env: let
        args = filterAttrs (_: v: v != null) env;
      in
        map (name: "${name}=${args.${name}}") (attrNames args);

      effectiveGames =
        mapAttrs (_: game: let
          mangohudEnable =
            if game.mangohud.enable == null
            then cfg.defaults.mangohud.enable
            else game.mangohud.enable;
        in {
          gamescope = {
            enable =
              if game.gamescope.enable == null
              then cfg.defaults.gamescope.enable
              else game.gamescope.enable;
            args = (cfg.defaults.gamescope.args // game.gamescope.args) // {mangoapp = mangohudEnable;};
          };
          gamemode.enable =
            if game.gamemode.enable == null
            then cfg.defaults.gamemode.enable
            else game.gamemode.enable;
          mangohud.enable = mangohudEnable;
          env = cfg.defaults.env // game.env;
          extraArgs = cfg.defaults.extraArgs ++ game.extraArgs;
        })
        cfg.games;

      mkCase = id: game: ''
        ${escapeShellArg id})
          gamescope_enable=${boolToString game.gamescope.enable}
          gamescope_args=(${concatMapStringsSep " " escapeShellArg (mkFlags game.gamescope.args)})
          gamemode_enable=${boolToString game.gamemode.enable}
          mangohud_enable=${boolToString game.mangohud.enable}
          game_env_args=(${concatMapStringsSep " " escapeShellArg (mkEnvArgs game.env)})
          extra_args=(${concatMapStringsSep " " escapeShellArg game.extraArgs})
          ;;
      '';

      script = pkgs.writeShellApplication {
        name = "game-wrapper";
        runtimeInputs = with pkgs; [gamescope gamemode];
        text = ''
          if [ "$#" -lt 1 ]; then
            echo "usage: game-wrapper <game-id> [--] <command> [args...]" >&2
            exit 1
          fi

          game_id="$1"
          shift

          gamescope_enable=${boolToString cfg.defaults.gamescope.enable}
          gamescope_args=(${concatMapStringsSep " " escapeShellArg (mkFlags cfg.defaults.gamescope.args)})
          gamemode_enable=${boolToString cfg.defaults.gamemode.enable}
          mangohud_enable=${boolToString cfg.defaults.mangohud.enable}
          game_env_args=(${concatMapStringsSep " " escapeShellArg (mkEnvArgs cfg.defaults.env)})
          extra_args=(${concatMapStringsSep " " escapeShellArg cfg.defaults.extraArgs})

          case "$game_id" in
            ${concatStrings (mapAttrsToList mkCase effectiveGames)}
            *) ;;
          esac

          if [ "''${1:-}" = "--" ]; then
            shift
          fi

          # Steam's %command% sometimes carries leading VAR=value assignments
          # which a shell would apply as a temporary environment for the
          # command but `exec` would otherwise try to run literally.
          env_args=()
          while [ "$#" -gt 0 ]; do
            case "$1" in
              [A-Za-z_]*=*)
                env_args+=("$1")
                shift
                ;;
              *)
                break
                ;;
            esac
          done

          cmd=("$@" "''${extra_args[@]}")

          if [ "$gamemode_enable" = "true" ]; then
            cmd=(gamemoderun "''${cmd[@]}")
          fi

          if [ "$gamescope_enable" = "true" ]; then
            cmd=(gamescope "''${gamescope_args[@]}" -- "''${cmd[@]}")
          fi

          if [ "$gamescope_enable" = "true" ] || [ "$mangohud_enable" != "true" ]; then
            cmd=(env -u MANGOHUD "''${cmd[@]}")
          else
            cmd=(env MANGOHUD=1 "''${cmd[@]}")
          fi

          if [ "''${#env_args[@]}" -gt 0 ]; then
            cmd=(env "''${env_args[@]}" "''${cmd[@]}")
          fi

          if [ "''${#game_env_args[@]}" -gt 0 ]; then
            cmd=(env "''${game_env_args[@]}" "''${cmd[@]}")
          fi

          exec "''${cmd[@]}"
        '';
      };

      wrapPackage = gameId: pkg: let
        binName = pkg.meta.mainProgram or pkg.pname or pkg.name;
      in
        pkgs.symlinkJoin {
          name = "${pkg.name}-gamewrapped";
          paths = [pkg];
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            original="$out/bin/${binName}"
            hidden="$out/bin/.${binName}-unwrapped"
            mv "$original" "$hidden"

            makeWrapper ${script}/bin/game-wrapper "$original" \
              --add-flags ${escapeShellArg gameId} \
              --add-flags -- \
              --add-flags "$hidden"

            if [ -d "$out/share/applications" ]; then
              for desktopFile in "$out"/share/applications/*.desktop; do
                [ -e "$desktopFile" ] || continue
                real="$(readlink -f "$desktopFile")"
                rm -f "$desktopFile"
                cp "$real" "$desktopFile"
                chmod +w "$desktopFile"
                substituteInPlace "$desktopFile" \
                  --replace-quiet "Exec=${pkg}/bin/${binName}" "Exec=$original" \
                  --replace-quiet "Exec=${binName}" "Exec=$original"
              done
            fi
          '';
        };

      exposeOnPath = pkg: let
        binName = pkg.meta.mainProgram or pkg.pname or pkg.name;
      in
        pkgs.symlinkJoin {
          name = "${pkg.name}-gamepath";
          paths = [pkg];
          nativeBuildInputs = [pkgs.makeWrapper];
          postBuild = ''
            wrapProgram "$out/bin/${binName}" \
              --prefix PATH : ${makeBinPath [script]}
          '';
        };
    in {
      programs.gaming.wrapper = {
        inherit script wrapPackage exposeOnPath;
      };
    };
}
