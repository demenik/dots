{lib, ...}: {
  name = "lang-ruby";

  moduleOptions = with lib; {
    lang.ruby = {
      enable = mkEnableOption "Enable Ruby language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Ruby lsp/linter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.ruby;
    packages = {
      inherit (pkgs) solargraph rubocop;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.ruby = {
        enable = true;
        inherit packages;
        lsps = ["solargraph"];
        linters = {
          ruby = ["rubocop"];
        };
        formatters = {};
      };
    };
}
