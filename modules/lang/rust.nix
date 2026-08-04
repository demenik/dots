{lib, ...}: {
  name = "lang-rust";

  moduleOptions = with lib; {
    lang.rust = {
      enable = mkEnableOption "Enable Rust language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Rust lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.rust;
    packages = {
      inherit (pkgs) clippy rustfmt;
      rust_analyzer = pkgs.rust-analyzer;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.rust = {
        enable = true;
        inherit packages;
        lsps = ["rust_analyzer"];
        linters = {
          rust = ["clippy"];
        };
        formatters = {
          rust = ["rustfmt"];
        };
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "rust-analyzer-lsp" = "${pkgs.claude-plugins}/plugins/rust-analyzer-lsp";
      };
    };
}
