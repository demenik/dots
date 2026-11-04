{
  name = "ai-caveman";

  overlays.home = [
    (final: prev: {
      cavemanSkillSrc = prev.fetchFromGitHub {
        owner = "JuliusBrussee";
        repo = "caveman";
        rev = "2e068f735253cce28256744804785f01887d9646";
        hash = "sha256-DFS9Xp9msSFF4WwdPd9RdghjBzc0x4yVomM6nxQWPKw=";
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
