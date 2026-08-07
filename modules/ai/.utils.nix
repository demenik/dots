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

  claudeCodePermissions = let
    toolCategories = {
      Bash = config.ai.permissions.bash;
      Read = config.ai.permissions.read;
      Write = config.ai.permissions.write;
      Edit = config.ai.permissions.edit;
      WebFetch = config.ai.permissions.webFetch;
      WebSearch = config.ai.permissions.webSearch;
    };

    wrapAction = action:
      lib.concatLists (
        lib.mapAttrsToList (tool: rules: map (p: "${tool}(${p})") rules.${action}) toolCategories
      );

    mcpRule = pattern: let
      m = builtins.match "([a-zA-Z0-9-]+)_(.*)" pattern;
    in
      if m != null
      then "mcp__${builtins.elemAt m 0}__${builtins.elemAt m 1}"
      else pattern;
  in {
    allow = wrapAction "allow" ++ map mcpRule config.ai.permissions.mcp.allow;
    ask = wrapAction "ask" ++ map mcpRule config.ai.permissions.mcp.ask;
    deny = wrapAction "deny" ++ map mcpRule config.ai.permissions.mcp.deny;
  };

  opencodePermissions = let
    patternAttrs = rules:
      lib.listToAttrs (
        map (p: lib.nameValuePair p "allow") rules.allow
        ++ map (p: lib.nameValuePair p "ask") rules.ask
        ++ map (p: lib.nameValuePair p "deny") rules.deny
      );

    simpleAction = rules:
      if rules.deny != []
      then "deny"
      else if rules.ask != []
      then "ask"
      else if rules.allow != []
      then "allow"
      else null;

    simpleActionAttrs = name: rules:
      lib.optionalAttrs (simpleAction rules != null) {${name} = simpleAction rules;};
  in
    {
      bash = patternAttrs config.ai.permissions.bash;
      read = patternAttrs config.ai.permissions.read;
      write = patternAttrs config.ai.permissions.write;
      edit = patternAttrs config.ai.permissions.edit;
    }
    // simpleActionAttrs "webfetch" config.ai.permissions.webFetch
    // simpleActionAttrs "websearch" config.ai.permissions.webSearch
    // patternAttrs config.ai.permissions.mcp
    // lib.filterAttrs (_: v: v != null) (
      lib.mapAttrs (
        name: rules:
          if name == "todowrite"
          then simpleAction rules
          else patternAttrs rules
      )
      config.ai.permissions.other
    );
}
