{pkgs, ...}: let
  librepods-wrapped = pkgs.symlinkJoin {
    name = "librepods";
    paths = [pkgs.librepods];
    buildInputs = [pkgs.makeWrapper];
    postBuild = ''
      wrapProgram "$out"/bin/librepods \
        --unset QT_STYLE_OVERRIDE
    '';
  };
in {
  home.packages = [
    librepods-wrapped
  ];
}
