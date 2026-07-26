{lib, ...}: {
  name = "lang-godot";

  moduleOptions = with lib; {
    lang.godot.enable = mkEnableOption "Enable Godot Engine (GDScript) language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.godot.enable {
      home.packages = with pkgs; [
        gdtoolkit_4
      ];

      lang.meta.godot = {
        enable = true;
        lsps = ["gdscript"];
        linters = {};
        formatters = {
          gdscript = ["gdformat"];
        };
      };
    };
}
