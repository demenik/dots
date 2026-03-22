{lib, ...}: let
  base16Names = [
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
  colorNames =
    base16Names
    ++ [
      "accent"
    ];

  hexToDec = hex: (fromTOML "val=0x${hex}").val;
in {
  name = "colors";
  moduleOptions = with lib; {
    colors =
      genAttrs base16Names (name:
        mkOption {
          type = types.strMatching "[0-9a-fA-F]{6}";
          description = "Base16 ${name} color";
          example = "1a1b26";
        })
      // {
        accent = mkOption {
          type = types.strMatching "[0-9a-fA-f]{6}";
          description = "Accent color (defaults to base0D)";
          example = "7aa2f7";
        };

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

        rgbFloat = genAttrs colorNames (name:
          mkOption {
            type = types.str;
            readOnly = true;
          });
        rFloat = genAttrs colorNames (name:
          mkOption {
            type = types.float;
            readOnly = true;
          });
        gFloat = genAttrs colorNames (name:
          mkOption {
            type = types.float;
            readOnly = true;
          });
        bFloat = genAttrs colorNames (name:
          mkOption {
            type = types.float;
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
        accent = mkOptionDefault config.colors.base0D;

        withHashtag = genAttrs colorNames (name: "#${config.colors.${name}}");

        r = genAttrs colorNames (name: toString (hexToDec (builtins.substring 0 2 config.colors.${name})));
        g = genAttrs colorNames (name: toString (hexToDec (builtins.substring 2 2 config.colors.${name})));
        b = genAttrs colorNames (name: toString (hexToDec (builtins.substring 4 2 config.colors.${name})));
        rgb = genAttrs colorNames (name: "${config.colors.r.${name}}, ${config.colors.g.${name}}, ${config.colors.b.${name}}");

        rFloat = genAttrs colorNames (name: (hexToDec (builtins.substring 0 2 config.colors.${name})) / 255.0);
        gFloat = genAttrs colorNames (name: (hexToDec (builtins.substring 2 2 config.colors.${name})) / 255.0);
        bFloat = genAttrs colorNames (name: (hexToDec (builtins.substring 4 2 config.colors.${name})) / 255.0);
        rgbFloat = genAttrs colorNames (name: "${toString config.colors.rFloat.${name}}, ${toString config.colors.gFloat.${name}}, ${toString config.colors.bFloat.${name}}");
      };
    };
}
