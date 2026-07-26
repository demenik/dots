{lib, ...}: {
  name = "lang-dart";

  moduleOptions = with lib; {
    lang.dart.enable = mkEnableOption "Enable Dart/Flutter language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.dart.enable {
      home.packages = with pkgs; [
        flutter
      ];

      lang.meta.dart = {
        enable = true;
        lsps = ["dartls"];
        linters = {};
        formatters = {};
      };
    };
}
