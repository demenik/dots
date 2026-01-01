{
  lib,
  pkgs,
  ...
}: {
  plugins.jdtls = {
    enable = true;
    settings = {
      cmd = [
        "${lib.getExe' pkgs.jdt-language-server "jdtls"}"
      ];
      root_dir.__raw = ''
        require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
      '';
    };
  };
}
