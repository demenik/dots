{lib, ...}: let
  colorNames = [
    "base00"
    "base01"
    "base02"
    "base03"
    "base04"
    "base05"
    "base06"
    "base07"
    "base08"
    "base09"
    "base0A"
    "base0B"
    "base0C"
    "base0D"
    "base0E"
    "base0F"
  ];

  hexToDec = hex: (fromTOML "val=0x${hex}").val;
in {
  name = "colors";
  moduleOptions = with lib; {
    colors =
      genAttrs colorNames (name:
        mkOption {
          type = types.strMatching "[0-9a-fA-F]{6}";
          description = "Base16 ${name} color";
          example = "1a1b26";
        })
      // {
        withHashtag = genAttrs colorNames (name:
          mkOption {
            type = types.str;
            readOnly = true;
          });

        rgb = genAttrs colorNames (name:
          mkOption {
            type = types.str;
            readOnly = true;
          });
        r = genAttrs colorNames (name:
          mkOption {
            type = types.str;
            readOnly = true;
          });
        g = genAttrs colorNames (name:
          mkOption {
            type = types.str;
            readOnly = true;
          });
        b = genAttrs colorNames (name:
          mkOption {
            type = types.str;
            readOnly = true;
          });
      };
  };

  moduleConfig = {
    config,
    lib,
    ...
  }:
    with lib; {
      colors = {
        withHashtag = genAttrs colorNames (name: "#${config.colors.${name}}");

        r = genAttrs colorNames (name: toString (hexToDec (builtins.substring 0 2 config.colros.${name})));
        g = genAttrs colorNames (name: toString (hexToDec (builtins.substring 2 2 config.colros.${name})));
        b = genAttrs colorNames (name: toString (hexToDec (builtins.substring 4 2 config.colros.${name})));

        rgb = genAttrs colorNames (name: "${config.colors.r.${name}}, ${config.colors.g.${name}}, ${config.colors.b.${name}}");
      };
    };
}
