{
  name = "ai-caveman";

  overlays.home = [
    (final: prev: {
      cavemanSkillSrc = prev.fetchFromGitHub {
        owner = "JuliusBrussee";
        repo = "caveman";
        rev = "d262ab3882952a59312ff3537cd86d894523c5ab";
        hash = "sha256-2xZHdWkWJrPAJ8++qW0Xmb3eORZ41e+GsZjIphqTtlI=";
      };
    })
  ];

  home = {
    pkgs,
    lib,
    ...
  }: let
    cavemanSkillsList = [
      "caveman"
      "caveman-compress"
      "caveman-commit"
      "caveman-help"
      "caveman-review"
    ];

    buildCavemanSkill = skillName:
      pkgs.stdenv.mkDerivation {
        pname = "skill-${skillName}";
        version = "git";

        src = pkgs.cavemanSkillSrc;

        installPhase = ''
          mkdir -p "$out"
          cp -r skills/"${skillName}"/* "$out"/
        '';
      };
  in {
    ai.skills = lib.mapAttrs (name: drv: {inherit drv;}) (lib.genAttrs cavemanSkillsList buildCavemanSkill);
  };
}
