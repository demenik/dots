{lib, ...}: {
  name = "lang-python";

  moduleOptions = with lib; {
    lang.python = {
      enable = mkEnableOption "Enable Python language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Python lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.python;
    packages = {
      inherit (pkgs) pyright ruff black;
      inherit (pkgs.python312Packages) flake8;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.python = {
        enable = true;
        inherit packages;
        lsps = ["pyright"];
        linters = {
          python = ["ruff"];
        };
        formatters = {
          python = ["black"];
        };
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "pyright-lsp" = "${pkgs.claude-plugins}/plugins/pyright-lsp";
      };
    };
}
