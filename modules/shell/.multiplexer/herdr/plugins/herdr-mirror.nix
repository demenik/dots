{lib, ...}: let
  utils = import ./.utils.nix;
  script = utils.latestRelease "nikok6/herdr-mirror";
in {
  overlays.home = [
    (final: prev: {
      # Prebuilt release binary, linux x86_64 only
      herdr-mirror-bin = final.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "herdr-mirror-bin";
        version = "0.4.3";

        passthru.fmUpdate = {
          inherit (finalAttrs) version;
          inherit script;
        };

        src = final.fetchurl {
          url = "https://github.com/nikok6/herdr-mirror/releases/download/v${finalAttrs.version}/herdr-mirror-linux-x86_64";
          hash = "sha256-FbZLS5OljpTnDmm0YhQGma/7soYxc35TnMo0vAnptig=";
        };

        dontUnpack = true;

        installPhase = ''
          install -Dm755 "$src" "$out"/bin/herdr-mirror
        '';
      });

      herdr-mirror = final.stdenvNoCC.mkDerivation (finalAttrs: {
        pname = "herdr-mirror";
        version = "0.4.3";

        passthru.fmUpdate = {
          inherit (finalAttrs) version;
          inherit script;
        };

        src = final.fetchFromGitHub {
          owner = "nikok6";
          repo = "herdr-mirror";
          rev = "v${finalAttrs.version}";
          hash = "sha256-dZIu4TcMkVDrRvnvgRMh7+8PpNaWB/i2/UkH/h0ZRW4=";
        };

        installPhase = ''
          cp -r . "$out"
          install -Dm755 ${final.herdr-mirror-bin}/bin/herdr-mirror "$out"/target/release/herdr-mirror
        '';

        dontFixup = true;
      });
    })
  ];

  moduleOptions = with lib; {
    programs.herdr.mirror = {
      settings = mkOption {
        type = with types; attrsOf anything;
        default = {};
        description = ''
          Global herdr-mirror options written to the root of
          `~/.config/herdr-mirror/hosts.toml`.
        '';
      };

      hosts = mkOption {
        type = with types; attrsOf (attrsOf anything);
        default = {};
        example = {work.target = "user@host";};
        description = ''
          Per-host mirror targets (`[hosts.<name>]`). `target` is required per
          host. When empty and `settings` is empty, no config file is written.
        '';
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.programs.herdr.mirror;

    hasConfig = cfg.hosts != {} || cfg.settings != {};
    hostsToml =
      (pkgs.formats.toml {}).generate "herdr-mirror-hosts.toml"
      (cfg.settings // {hosts = cfg.hosts;});
  in {
    # Plugin keybindings hardcode the absolute ~/.local/bin/herdr-mirror path
    home.file.".local/bin/herdr-mirror".source = "${pkgs.herdr-mirror-bin}/bin/herdr-mirror";

    programs.herdr.plugins = [
      {
        package = pkgs.herdr-mirror;
        runtimeInputs = [pkgs.openssh];
        configFiles = lib.mkIf hasConfig {
          "herdr-mirror/hosts.toml".source = hostsToml;
        };
      }
    ];

    programs.herdr.settings.keys = lib.mkIf hasConfig {
      new_tab = "prefix+alt+c";
      new_workspace = "prefix+alt+n";
      split_vertical = lib.mkForce "prefix+alt+#";
      split_horizontal = lib.mkForce "prefix+alt+-";

      command = [
        {
          key = "prefix+c";
          type = "plugin_action";
          command = "mirror.remote-new-tab";
          description = "New tab (remote-aware)";
        }
        {
          key = "prefix+shift+n";
          type = "plugin_action";
          command = "mirror.new-workspace-pick";
          description = "New workspace (host picker)";
        }
        {
          key = "prefix+#";
          type = "plugin_action";
          command = "mirror.remote-split-right";
          description = "Split right (remote-aware)";
        }
        {
          key = "prefix+-";
          type = "plugin_action";
          command = "mirror.remote-split-down";
          description = "Split down (remote-aware)";
        }
      ];
    };
  };
}
