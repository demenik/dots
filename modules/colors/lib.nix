rec {
  hexToDec = hex: (fromTOML "val=0x${hex}").val;

  decToHex = dec: let
    hexDigits = ["0" "1" "2" "3" "4" "5" "6" "7" "8" "9" "a" "b" "c" "d" "e" "f"];
    clamped =
      if dec < 0
      then 0
      else if dec > 255
      then 255
      else dec;
    d1 = clamped / 16;
    d2 = clamped - (d1 * 16);
  in
    builtins.elemAt hexDigits d1 + builtins.elemAt hexDigits d2;

  clamp = min: max: val:
    if val < min
    then min
    else if val > max
    then max
    else val;

  mix = hex1: hex2: percentage: let
    p = clamp 0 100 percentage;

    r1 = hexToDec (builtins.substring 0 2 hex1);
    g1 = hexToDec (builtins.substring 2 2 hex1);
    b1 = hexToDec (builtins.substring 4 2 hex1);

    r2 = hexToDec (builtins.substring 0 2 hex2);
    g2 = hexToDec (builtins.substring 2 2 hex2);
    b2 = hexToDec (builtins.substring 4 2 hex2);

    r = (r1 * (100 - p) + r2 * p) / 100;
    g = (g1 * (100 - p) + g2 * p) / 100;
    b = (b1 * (100 - p) + b2 * p) / 100;
  in
    decToHex r + decToHex g + decToHex b;

  lighten = hex: percentage: mix hex "ffffff" percentage;
  darken = hex: percentage: mix hex "000000" percentage;

  steps = hex: {
    "50" = lighten hex 90;
    "100" = lighten hex 80;
    "200" = lighten hex 60;
    "300" = lighten hex 40;
    "400" = lighten hex 20;
    "500" = hex;
    "600" = darken hex 20;
    "700" = darken hex 40;
    "800" = darken hex 60;
    "900" = darken hex 80;
    "950" = darken hex 90;
  };
}
