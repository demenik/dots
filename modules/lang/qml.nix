{lib, ...}: {
  name = "lang-qml";

  moduleOptions = with lib; {
    lang.qml = {
      enable = mkEnableOption "Enable QML language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add QML lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.qml;
    packages = {
      qmlls = pkgs.qt6.qtdeclarative;
      qmllint = pkgs.qt6.qtdeclarative;
      qmlformat = pkgs.qt6.qtdeclarative;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.qml = {
        enable = true;
        inherit packages;
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
