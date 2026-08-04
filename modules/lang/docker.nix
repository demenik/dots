{lib, ...}: {
  name = "lang-docker";

  moduleOptions = with lib; {
    lang.docker = {
      enable = mkEnableOption "Enable Docker language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Docker lsp tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.docker;
    packages = {
      dockerls = pkgs.dockerfile-language-server;
      docker_compose_language_service = pkgs.docker-compose-language-service;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.docker = {
        enable = true;
        inherit packages;
        lsps = ["dockerls" "docker_compose_language_service"];
        linters = {};
        formatters = {};
      };
    };
}
