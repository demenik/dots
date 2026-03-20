{pkgs, ...}: let
  mcmojaveCursors = pkgs.stdenv.mkDerivation {
    pname = "mcmojave-cursors";
    version = "24/2/2021";
    src = pkgs.fetchFromGitHub {
      owner = "vinceliuice";
      repo = "McMojave-cursors";
      rev = "7d0bfc1f91028191cdc220b87fd335a235ee4439";
      hash = "sha256-4YqSucpxA7jsuJ9aADjJfKRPgPR89oq2l0T1N28+GV0=";
    };
    dontBuild = true;

    installPhase = ''
      mkdir -p "$out"/share/icons
      cp -pr "$src"/dist "$out"/share/icons/McMojave-cursors
    '';
  };
in {
  home.pointerCursor = {
    name = "McMojave-cursors";
    package = mcmojaveCursors;
    size = 22;
    gtk.enable = true;
    x11.enable = true;
  };
}
