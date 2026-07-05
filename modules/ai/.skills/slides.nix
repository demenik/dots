{
  home = {pkgs, ...}: let
    slidesRepo = pkgs.fetchFromGitHub {
      owner = "zarazhangrui";
      repo = "frontend-slides";
      rev = "main";
      hash = "sha256-qp2oCn5+YbMZrWCnN7zt/ee1nm/vBGsdb+AIUjIldyY=";
    };

    buildSlidesSkill = pkgs.stdenv.mkDerivation {
      pname = "skill-slides";
      version = "git";

      src = slidesRepo;

      installPhase = ''
        mkdir -p "$out"
        cp -r * "$out"/
      '';
    };
  in {
    ai.skills.slides = {
      drv = buildSlidesSkill;
    };
  };
}
