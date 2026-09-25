{
  name = "ai-caveman";

  overlays.home = [
    (final: prev: {
      cavemanSkillSrc = prev.fetchFromGitHub {
        owner = "JuliusBrussee";
        repo = "caveman";
        rev = "2fd153c67988e980fb0b2455c90832159a6a5a25";
        hash = "sha256-KFfU8LmNajKLZcOXOFisn4beTcg2YL+rpasr39UgSZE=";
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
