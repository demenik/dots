{
  name = "ai-caveman";

  overlays.home = [
    (final: prev: {
      cavemanSkillSrc = prev.fetchFromGitHub {
        owner = "JuliusBrussee";
        repo = "caveman";
        rev = "0d95a81d35a9f2d123a5e9430d1cfc43d55f1bb0";
        hash = "sha256-VqRHx3/4SSCnEh3cUJ/he5saIfwNhS0hOzoH/wwtU2o=";
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
