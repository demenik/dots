{lib, ...}: {
  name = "lang-db";

  moduleOptions = with lib; {
    lang.db.enable = mkEnableOption "Enable Database (SQL, GraphQL) language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.db.enable {
      home.packages = with pkgs; [
        sqlfluff
        sqruff
      ];

      lang.meta.db = {
        enable = true;
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
