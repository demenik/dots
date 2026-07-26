{lib, ...}: {
  name = "lang-docker";

  moduleOptions = with lib; {
    lang.docker.enable = mkEnableOption "Enable Docker language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.docker.enable {
      home.packages = with pkgs; [
        dockerfile-language-server-nodejs
        docker-compose-language-service
      ];

      lang.meta.docker = {
        enable = true;
        lsps = ["dockerls" "docker_compose_language_service"];
        linters = {};
        formatters = {};
      };
    };
}
