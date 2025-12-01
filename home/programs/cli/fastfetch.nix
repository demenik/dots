{
  programs.fastfetch = {
    enable = true;

    settings = {
      display = {
        separator = " = ";
      };

      modules = let
        mkLiteral = type: key: format: {
          inherit type;
          key = "  ${key}";
          format = "${format};";
        };
        mkString = type: key: format: mkLiteral type key "\"${format}\"";
        emptyLine = {
          type = "custom";
          format = "";
        };
      in [
        {
          type = "title";
          format = "{host-name-colored}.users.{user-name-colored} = ｛"; # ｛｝
        }

        (mkString "host" "host" "{family}")
        (mkString "cpu" "cpu" "{name} ({cores-physical}C/{cores-logical}T) @ {freq-max}")
        (mkString "memory" "memory" "{used}/{total} ({percentage})")
        (mkString "disk" "disk" "{name} ({filesystem}) {size-used}/{size-total} ({size-percentage})")
        (mkString "os" "os" "{name} {release}")
        (mkString "kernel" "kernel" "{sysname} {arch} {display-version}")
        (mkString "localip" "ip" "{ipv4} {ifname}") # last seen

        emptyLine

        (mkString "wm" "wm" "{pretty-name} {version} ({protocol-name})")
        (mkString "editor" "editor" "{name} {version}")

        {
          type = "custom";
          format = "};";
        }
      ];
    };
  };
}
