{lib, ...}: let
  langPaths = [
    ./configs.nix
    ./cpp.nix
    ./csharp.nix
    ./dart.nix
    ./db.nix
    ./docker.nix
    ./go.nix
    ./godot.nix
    ./java.nix
    ./kotlin.nix
    ./latex.nix
    ./lua.nix
    ./markdown.nix
    ./nix.nix
    ./python.nix
    ./qml.nix
    ./ruby.nix
    ./rust.nix
    ./shell.nix
    ./web.nix
  ];
  langs = map (p: lib.removeSuffix ".nix" (baseNameOf (toString p))) langPaths;
in {
  name = "lang";
  modules = langPaths;

  moduleOptions = with lib; {
    lang = {
      "*" = {
        enable = mkEnableOption "Enable all language toolchains";
      };
      meta = mkOption {
        description = "Language metadata of enabled configurations";
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = false;
            };
            lsps = mkOption {
              type = types.listOf types.str;
              default = [];
            };
            linters = mkOption {
              type = types.attrsOf (types.listOf types.str);
              default = {};
            };
            formatters = mkOption {
              type = types.attrsOf types.anything;
              default = {};
            };
            packages = mkOption {
              description = "Tool id (as used in lsps/linters/formatters) to package derivation, for consumers that want the binary without relying on PATH";
              type = types.attrsOf types.package;
              default = {};
            };
          };
        });
      };
    };
  };

  moduleConfig = {
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang."*".enable {
      lang = lib.genAttrs langs (name: {
        enable = lib.mkDefault true;
      });
    };

  home = {config, ...}: {
    home.file.".config/ai/lang-tools.json".text = builtins.toJSON config.lang.meta;
  };
}
