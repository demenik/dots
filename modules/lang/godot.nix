{lib, ...}: {
  name = "lang-godot";

  moduleOptions = with lib; {
    lang.godot = {
      enable = mkEnableOption "Enable Godot Engine (GDScript) language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Godot formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.godot;
    packages = {
      gdformat = pkgs.gdtoolkit_4;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.godot = {
        enable = true;
        inherit packages;
        lsps = ["gdscript"];
        linters = {};
        formatters = {
          gdscript = ["gdformat"];
        };
      };
    };
}
