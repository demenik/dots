{lib, ...}: {
  name = "lang-go";

  moduleOptions = with lib; {
    lang.go.enable = mkEnableOption "Enable Go language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.go.enable {
      home.packages = with pkgs; [
        golangci-lint
        go
        gotools
        gopls
      ];

      lang.meta.go = {
        enable = true;
        lsps = ["gopls"];
        linters = {
          go = ["golangcilint"];
        };
        formatters = {
          go = ["goimports" "gofmt"];
        };
      };
    };
}
