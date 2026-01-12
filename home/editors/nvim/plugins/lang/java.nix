{
  lib,
  pkgs,
  ...
}: let
  google-style-xml = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
    hash = "sha256-51Uku2fj/8iNXGgO11JU4HLj28y7kcSgxwjc+r8r35E=";
  };
in {
  plugins.jdtls = {
    enable = true;
    settings = {
      cmd = [
        "${lib.getExe' pkgs.jdt-language-server "jdtls"}"
      ];
      root_dir.__raw = ''
        require("jdtls.setup").find_root { ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" }
      '';
      settings.java = {
        format = {
          enabled = true;
          settings = {
            url = "file://${google-style-xml}";
            profile = "GoogleStyle";
          };
        };
      };
    };
  };
}
