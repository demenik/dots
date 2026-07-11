{
  name = "ai-slides";

  overlays.home = [
    (final: prev: {
      slidesSkillSrc = prev.fetchFromGitHub {
        owner = "zarazhangrui";
        repo = "frontend-slides";
        rev = "9906a34d640d2111f724544cbc50f7f130569ae1";
        hash = "sha256-qp2oCn5+YbMZrWCnN7zt/ee1nm/vBGsdb+AIUjIldyY=";
      };
    })
  ];

  home = {pkgs, ...}: let
    buildSlidesSkill = pkgs.stdenv.mkDerivation {
      pname = "skill-slides";
      version = "git";

      src = pkgs.slidesSkillSrc;

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
