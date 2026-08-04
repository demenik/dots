{lib, ...}: {
  name = "lang-python";

  moduleOptions = with lib; {
    lang.python.enable = mkEnableOption "Enable Python language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.python.enable {
      home.packages = with pkgs; [
        ruff
        black
        python312Packages.flake8
        pyright
      ];

      lang.meta.python = {
        enable = true;
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
