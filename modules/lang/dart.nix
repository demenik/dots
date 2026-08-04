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
      home.packages = [pkgs.flutter];

      lang.meta.dart = {
        enable = true;
        packages = {
          dartls = pkgs.flutter;
        };
        lsps = ["dartls"];
        linters = {};
        formatters = {};
      };
    };
}
