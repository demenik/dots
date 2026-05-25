{lib, ...}: {
  moduleOptions = with lib; {
    theme = {
      templates = mkOption {
        description = "Theme templates configuration";
        default = {};
        type = types.attrsOf (types.submodule {
          options = {
            enable = mkOption {
              type = types.bool;
              default = true;
              description = "Enable this template";
            };
            target = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Target file path relative to home directory";
            };
            post_hook = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "Command to run after template changes";
            };
            text = mkOption {
              type = types.nullOr types.str;
              default = null;
              description = "The template content";
            };
            source = mkOption {
              type = types.nullOr types.path;
              default = null;
              description = "Path to the template file. Mutually exclusive with text.";
            };
          };
        });
      };
    };
  };
}
