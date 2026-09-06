{lib, ...}: {
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
    version = "0.4.3";
    cfg = config.programs.herdr.mirror;

    plat = {
      x86_64-linux = {
        arch = "x86_64";
        hash = "sha256-FbZLS5OljpTnDmm0YhQGma/7soYxc35TnMo0vAnptig=";
      };
      aarch64-linux = {
        arch = "aarch64";
        hash = "sha256-eYmIMgVn3A3R+uiqczrW+Ffx3Hk8+8+fqBEgr0WniX8=";
      };
    };
    inherit (plat.${pkgs.stdenv.hostPlatform.system}) arch hash;

    src = pkgs.fetchFromGitHub {
      owner = "nikok6";
      repo = "herdr-mirror";
      rev = "195398c1275f9f3d18ddff70282149005a2bec01";
      hash = "sha256-dZIu4TcMkVDrRvnvgRMh7+8PpNaWB/i2/UkH/h0ZRW4=";
    };

    bin = pkgs.fetchurl {
      url = "https://github.com/nikok6/herdr-mirror/releases/download/v${version}/herdr-mirror-linux-${arch}";
      inherit hash;
    };

    hasConfig = cfg.hosts != {} || cfg.settings != {};
    hostsToml =
      (pkgs.formats.toml {}).generate "herdr-mirror-hosts.toml"
      (cfg.settings // {hosts = cfg.hosts;});

    pkg = pkgs.runCommand "herdr-mirror-${version}" {} ''
      cp -r "${src}" "$out"
      chmod -R u+w "$out"
      install -Dm755 "${bin}" "$out"/target/release/herdr-mirror
    '';
  in {
    # Plugin keybindings hardcode the absolute ~/.local/bin/herdr-mirror path
    home.file.".local/bin/herdr-mirror".source = "${pkg}/target/release/herdr-mirror";

    programs.herdr.plugins = [
      {
        package = pkg;
        runtimeInputs = [pkgs.openssh];
        configFiles = lib.mkIf hasConfig {
          "herdr-mirror/hosts.toml".source = hostsToml;
        };
      }
    ];
  };
}
