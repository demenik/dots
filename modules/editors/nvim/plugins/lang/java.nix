{
  pkgs,
  lib,
  config,
  ...
}: let
  google-style-xml = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/google/styleguide/gh-pages/eclipse-java-google-style.xml";
    hash = "sha256-51Uku2fj/8iNXGgO11JU4HLj28y7kcSgxwjc+r8r35E=";
  };
in {
  programs.nixvim = lib.mkIf config.lang.java.enable {
    plugins = {
      jdtls = {
        enable = true;
        settings = {
          cmd = [(lib.getExe' config.lang.meta.java.packages.jdtls "jdtls")];
          root_dir.__raw = ''
            require("jdtls.setup").find_root({ ".git", "mvnw", "gradlew", "pom.xml", "build.gradle" })
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
    };
  };
}
