{
  pkgs,
  lib,
  config,
}: rec {
  mkSkillDrv = name: skill:
    if skill.drv != null
    then skill.drv
    else if skill.text != null
    then pkgs.writeTextDir "SKILL.md" skill.text
    else if skill.path != null
    then skill.path
    else throw "Skill ${name} must define drv, text, or path";

  mkSkillDirLinks = basePath:
    lib.mapAttrs' (
      name: skill:
        lib.nameValuePair "${basePath}/${name}" {source = mkSkillDrv name skill;}
    )
    config.ai.skills;

  allEnvList = lib.flatten (
    lib.mapAttrsToList (
      n: s:
        lib.mapAttrsToList (
          envName: envConfig: {
            inherit envName;
            inherit (envConfig) path text;
          }
        )
        s.env
    )
    config.ai.mcp
  );

  uniqueEnvs = lib.unique allEnvList;

  wrapperArgs =
    map (
      e:
        if e.path != null
        then "--run 'export ${e.envName}=$(cat \"${e.path}\")'"
        else if e.text != null
        then "--run 'export ${e.envName}=\"${e.text}\"'"
        else ""
    )
    uniqueEnvs;

  getCommand = server:
    if server.type == "local" && server.command != null && (builtins.length server.command > 0)
    then builtins.head server.command
    else null;

  getArgs = server:
    if server.type == "local" && server.command != null && (builtins.length server.command > 0)
    then lib.tail server.command
    else null;
}
