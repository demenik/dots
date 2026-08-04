{lib, ...}: {
  name = "lang-db";

  moduleOptions = with lib; {
    lang.db = {
      enable = mkEnableOption "Enable Database (SQL, GraphQL) language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Database lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.db;
    packages = {
      inherit (pkgs) sqruff sqlfluff;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.db = {
        enable = true;
        inherit packages;
        lsps = ["sqruff" "graphql"];
        linters = {
          sql = ["sqlfluff"];
        };
        formatters = {
          sql = ["sqruff"];
        };
      };
    };
}
