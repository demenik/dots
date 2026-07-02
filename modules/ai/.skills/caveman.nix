{
  home = {
    pkgs,
    lib,
    ...
  }: let
    cavemanRepo = pkgs.fetchFromGitHub {
      owner = "JuliusBrussee";
      repo = "caveman";
      rev = "main";
      hash = "sha256-FbmfhFaPs/SnSZdfNdErdIUHXt1FfBzErpPpLy8kdIc=";
    };

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

        src = cavemanRepo;

        installPhase = ''
          mkdir -p "$out"
          cp -r skills/"${skillName}"/* "$out"/
        '';
      };
  in {
    ai.skills = lib.mapAttrs (name: drv: {inherit drv;}) (lib.genAttrs cavemanSkillsList buildCavemanSkill);
  };
}
