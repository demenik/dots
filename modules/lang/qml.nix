{lib, ...}: {
  name = "lang-qml";

  moduleOptions = with lib; {
    lang.qml.enable = mkEnableOption "Enable QML language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.qml.enable {
      home.packages = with pkgs; [
        qt6.qtdeclarative
      ];

      lang.meta.qml = {
        enable = true;
        lsps = ["qmlls"];
        linters = {
          qml = ["qmllint"];
        };
        formatters = {
          qml = ["qmlformat"];
        };
      };
    };
}
