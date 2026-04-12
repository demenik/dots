{
  pkgs,
  lib,
  ...
}: let
  cavemanRepo = pkgs.fetchFromGitHub {
    owner = "JuliusBrussee";
    repo = "caveman";
    rev = "main";
    hash = "sha256-gDPgQx1TIhGrJ2EVvEoDY+4MXdlI79zdcx6pL5nMEG4=";
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
