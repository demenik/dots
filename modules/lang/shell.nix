{lib, ...}: {
  name = "lang-shell";

  moduleOptions = with lib; {
    lang.shell = {
      enable = mkEnableOption "Enable Shell scripting language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Shell lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.shell;
    packages = {
      inherit (pkgs) shellcheck shfmt;
      bashls = pkgs.bash-language-server;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.shell = {
        enable = true;
        inherit packages;
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
