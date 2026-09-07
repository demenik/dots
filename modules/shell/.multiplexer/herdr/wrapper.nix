{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib) mkOption mkIf types;

  cfg = config.programs.herdr;

  artifacts =
    pkgs.runCommand "herdr-integration-artifacts" {
      nativeBuildInputs = lib.optional (cfg.package != null) cfg.package;
    }
    ''
      export HOME="$(mktemp -d)"
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_STATE_HOME="$HOME/.local/state"
      export XDG_DATA_HOME="$HOME/.local/share"
      mkdir -p "$HOME/.claude" "$HOME/.config/opencode/plugins"
      echo '{}' >"$HOME/.claude/settings.json"

      herdr integration install claude >/dev/null 2>&1 || true
      herdr integration install opencode >/dev/null 2>&1 || true

      mkdir -p "$out/claude" "$out/opencode"
      cp "$HOME/.claude/hooks/herdr-agent-state.sh" "$out/claude/herdr-agent-state.sh"
      cp "$HOME/.config/opencode/plugins/herdr-agent-state.js" "$out/opencode/herdr-agent-state.js"
      cp "$HOME/.config/opencode/herdr-tui-session.js" "$out/opencode/herdr-tui-session.js"
    '';

  supported = ["claude" "opencode"];

  targets = {
    claude = {
      guard = config.programs.claude-code.enable;
      hm.programs.claude-code.settings.hooks.SessionStart = [
        {
          matcher = "*";
          hooks = [
            {
              type = "command";
              command = "bash '${artifacts}/claude/herdr-agent-state.sh' session";
              timeout = 10;
            }
          ];
        }
      ];
    };

    opencode = {
      guard = config.programs.opencode.enable;
      hm.xdg.configFile = {
        "opencode/plugins/herdr-agent-state.js".source = "${artifacts}/opencode/herdr-agent-state.js";
        "opencode/plugins/herdr-tui-session.js".source = "${artifacts}/opencode/herdr-tui-session.js";
      };
    };
  };

  pluginPath = lib.makeBinPath (lib.concatMap (p: p.runtimeInputs) cfg.plugins);

  herdrBin = lib.optionalString (cfg.package != null) (lib.getExe cfg.package);

  renderEnvFile = settings:
    lib.concatStringsSep "\n" (
      lib.mapAttrsToList
      (k: v: "${k}=${
        if lib.isBool v
        then lib.boolToString v
        else toString v
      }")
      settings
    );

  pluginSettingsFiles = lib.listToAttrs (
    lib.concatMap
    (p:
      lib.optional (p.settingsFile != null) {
        name = p.settingsFile;
        value.text = renderEnvFile p.settings;
      })
    cfg.plugins
  );

  linkPlugin = p: let
    idExports = lib.optionalString (p.id != null) ''
      export HERDR_PLUGIN_CONFIG_DIR=${lib.escapeShellArg "${config.xdg.configHome}/herdr/plugins/config/${p.id}"}
      export HERDR_PLUGIN_STATE_DIR=${lib.escapeShellArg "${config.xdg.stateHome}/herdr/plugins/${p.id}"}
    '';
    link = "run ${herdrBin} plugin link ${lib.escapeShellArg "${p.package}"} >/dev/null 2>&1 || true";
    setup = lib.optionalString (p.setup != "") ''
      (
        export HERDR=${lib.escapeShellArg herdrBin}
        export HERDR_PLUGIN_DIR=${lib.escapeShellArg "${p.package}"}
        ${idExports}${p.setup}
      )
    '';
  in
    lib.concatStringsSep "\n" ([link] ++ lib.optional (setup != "") setup);

  pluginActivation = lib.concatStringsSep "\n" (
    map linkPlugin cfg.plugins
    ++ lib.optional (lib.any (p: p.reloadConfig) cfg.plugins)
    "run ${herdrBin} server reload-config >/dev/null 2>&1 || true"
  );

  wrappedPackage = pkgs.symlinkJoin {
    name = "herdr-wrapped";
    paths = [cfg.wrapper.package];
    nativeBuildInputs = [pkgs.makeWrapper];
    postBuild = lib.optionalString (pluginPath != "") ''
      wrapProgram "$out/bin/herdr" --prefix PATH : ${pluginPath}
    '';
    meta.mainProgram = "herdr";
  };
in {
  options.programs.herdr = {
    wrapper.package = mkOption {
      type = types.package;
      default = pkgs.herdr;
      description = "Base herdr package the wrapper wraps.";
    };

    integrations = mkOption {
      type = types.listOf (types.enum supported);
      default = [];
      example = ["claude" "opencode"];
      description = ''
        herdr agent integrations to install. Each wires the bundled hook script
        or plugin (pinned to the herdr package, referenced from the store) into
        the agent's config. An integration listed here is skipped unless its
        matching agent module is enabled.
      '';
    };

    plugins = mkOption {
      default = [];
      description = ''
        herdr plugins to link on activation. A bare package is coerced to
        `{ package = <pkg>; }`. Each package must be a directory containing a
        built `herdr-plugin.toml`; run any manifest build steps in the
        derivation, since `herdr plugin link` does not. `runtimeInputs` are
        prefixed onto herdr's PATH so the plugin's own commands resolve.
        `configFiles` are merged into `xdg.configFile` so a plugin can ship
        its own declaratively rendered config; `settings` + `settingsFile`
        cover the common `KEY=value` env-file case. `setup` runs a shell
        snippet on activation after the link (for plugins with an imperative
        `configure` step), and `reloadConfig` reloads a live server afterward.
      '';
      type = types.listOf (types.coercedTo types.package (package: {inherit package;}) (types.submodule {
        options = {
          package = mkOption {
            type = types.package;
            description = "Directory containing a built `herdr-plugin.toml`.";
          };
          runtimeInputs = mkOption {
            type = types.listOf types.package;
            default = [];
            description = "Packages added to herdr's PATH for this plugin's commands.";
          };
          configFiles = mkOption {
            type = types.attrsOf types.anything;
            default = {};
            description = ''
              Entries merged into `xdg.configFile` (paths relative to
              `$XDG_CONFIG_HOME`) for this plugin's config files.
            '';
          };
          id = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "herdr-agent-quota";
            description = ''
              Plugin id from its `herdr-plugin.toml`. When set, `setup` runs
              with `HERDR_PLUGIN_CONFIG_DIR` and `HERDR_PLUGIN_STATE_DIR`
              exported to the directories herdr uses for this plugin at
              runtime, so a `configure`-style tool writes where the running
              plugin reads.
            '';
          };
          settings = mkOption {
            type = types.attrsOf (types.oneOf [types.str types.int types.bool]);
            default = {};
            example = {HERDR_AUTO_TITLE_MAX_LENGTH = 24;};
            description = ''
              `KEY=value` pairs rendered into `settingsFile` as an env file
              (booleans become `true`/`false`). Ignored without `settingsFile`.
            '';
          };
          settingsFile = mkOption {
            type = types.nullOr types.str;
            default = null;
            example = "herdr-auto-title/config.env";
            description = ''
              Path relative to `$XDG_CONFIG_HOME` for the env file rendered
              from `settings`. Merged into `xdg.configFile` alongside
              `configFiles`.
            '';
          };
          setup = mkOption {
            type = types.lines;
            default = "";
            description = ''
              Shell run on activation immediately after this plugin is linked.
              Use home-manager's `run` wrapper for dry-run support. `$HERDR` is
              the herdr binary and `$HERDR_PLUGIN_DIR` the linked plugin path;
              `id` adds the `HERDR_PLUGIN_*_DIR` exports. Pair with
              `reloadConfig` when the snippet writes herdr's own config.
            '';
          };
          reloadConfig = mkOption {
            type = types.bool;
            default = false;
            description = ''
              Run `herdr server reload-config` once after every plugin `setup`
              snippet, so a live server picks up config a snippet wrote.
            '';
          };
        };
      }));
    };
  };

  config = mkIf cfg.enable (lib.mkMerge (
    (
      map
      (name: mkIf (lib.elem name cfg.integrations && targets.${name}.guard) targets.${name}.hm)
      supported
    )
    ++ [
      (mkIf (pluginPath != "") {programs.herdr.package = wrappedPackage;})

      (mkIf (cfg.plugins != []) {
        xdg.configFile = lib.mkMerge (
          (map (p: p.configFiles) cfg.plugins) ++ [pluginSettingsFiles]
        );
      })

      (mkIf (cfg.plugins != [] && cfg.package != null) {
        home.activation.herdrPlugins =
          lib.hm.dag.entryAfter ["writeBoundary"] pluginActivation;
      })
    ]
  ));
}
