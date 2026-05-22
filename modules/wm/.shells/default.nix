{lib, ...}: {
  name = "wm-shells";

  moduleOptions = with lib; {
    theme = {
      templates = mkOption {
        description = "Theme templates configuration";
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            target = mkOption {
              type = types.str;
              description = "Target file path relative to home directory";
            };
            post_hook = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Command to run after template changes";
            };
            text = mkOption {
              type = types.str;
              description = "The template content";
            };
          };
        });
      };
    };
  };
}
