{
  name = "ai-caveman";

  overlays.home = [
    (final: prev: {
      cavemanSkillSrc = prev.fetchFromGitHub {
        owner = "JuliusBrussee";
        repo = "caveman";
        rev = "15581d14007fd01fb3f132016741962f34936ca2";
        hash = "sha256-GuCK3oy0DsMOQq7gHjIY/aeaukJcTvelfg+tp7R7Du4=";
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
