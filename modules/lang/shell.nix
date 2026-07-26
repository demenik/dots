{lib, ...}: {
  name = "lang-shell";

  moduleOptions = with lib; {
    lang.shell.enable = mkEnableOption "Enable Shell scripting language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.shell.enable {
      home.packages = with pkgs; [
        shfmt
        shellcheck
        bash-language-server
      ];

      lang.meta.shell = {
        enable = true;
        lsps = ["bashls"];
        linters = {
          bash = ["shellcheck"];
        };
        formatters = {
          sh = ["shellcheck" "shfmt"];
        };
      };
    };
}
