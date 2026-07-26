{lib, ...}: {
  name = "lang-rust";

  moduleOptions = with lib; {
    lang.rust.enable = mkEnableOption "Enable Rust language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.rust.enable {
      home.packages = with pkgs; [
        rustfmt
        clippy
        rust-analyzer
      ];

      lang.meta.rust = {
        enable = true;
        lsps = ["rust_analyzer"];
        linters = {
          rust = ["clippy"];
        };
        formatters = {
          rust = ["rustfmt"];
        };
      };
    };
}
