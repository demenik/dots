{
  pkgs,
  inputs,
  ...
}: let
  mcmojavePkg = pkgs.stdenv.mkDerivation {
    pname = "mcmojave-cursors";
    version = "24/2/2021";
    src = inputs.mcmojave-cursors;
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/share/icons
      cp -pr $src/dist $out/share/icons/McMojave-cursors
    '';
  };
in {
  stylix.cursor = {
    name = "McMojave-cursors";
    package = mcmojavePkg;
    size = 22;
  };
}
