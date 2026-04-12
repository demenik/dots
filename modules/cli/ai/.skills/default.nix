{
  pkgs,
  lib,
  ...
}: let
  skillFiles = [
    ./caveman.nix
  ];

  importedSkills = map (path: import path {inherit pkgs lib;}) skillFiles;
  allSkillsAttrSet = lib.mergeAttrsList importedSkills;

  mkSkillDirLinks = basePath:
    lib.mapAttrs' (
      name: drv:
        lib.nameValuePair "${basePath}/${name}" {source = drv;}
    )
    allSkillsAttrSet;
in {
  skills = allSkillsAttrSet;
  inherit mkSkillDirLinks;
}
