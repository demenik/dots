{lib, ...}: {
  name = "lang-go";

  moduleOptions = with lib; {
    lang.go = {
      enable = mkEnableOption "Enable Go language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add the Go lsp/linter to PATH (the go toolchain is always added)";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.go;
    packages = {
      inherit (pkgs) gopls;
      golangcilint = pkgs.golangci-lint;
      goimports = pkgs.gotools;
      gofmt = pkgs.go;
    };
  in
    lib.mkIf cfg.enable {
      home.packages =
        [pkgs.go pkgs.gotools]
        ++ lib.optionals cfg.onPath [pkgs.gopls pkgs.golangci-lint];

      lang.meta.go = {
        enable = true;
        inherit packages;
        lsps = ["gopls"];
        linters = {
          go = ["golangcilint"];
        };
        formatters = {
          go = ["goimports" "gofmt"];
        };
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "gopls-lsp" = "${pkgs.claude-plugins}/plugins/gopls-lsp";
      };
    };
}
