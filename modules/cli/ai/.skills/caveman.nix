{
  pkgs,
  lib,
  ...
}: let
  cavemanRepo = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "main";
    hash = "sha256-pHPMQGr9/ufsUODmqHm2T6sCOaeOOJl4baX4OeeYp6k=";
  };

  cavemanSkillsList = [
    "caveman"
    "compress"
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
in
  lib.genAttrs cavemanSkillsList buildCavemanSkill
