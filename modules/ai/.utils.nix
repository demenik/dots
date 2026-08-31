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

  # Only remote servers need their secret in the CLI process environment, since
  # it is consumed as a request header. Local-server secrets are scoped to a
  # per-server launcher script instead (see mkMcpServer/mcpLocalCommand)
  remoteEnvList = lib.flatten (
    lib.mapAttrsToList (
      _: s:
        lib.optionals (s.type == "remote") (
          lib.mapAttrsToList (
            envName: envConfig: {
              inherit envName;
              inherit (envConfig) path text;
            }
          )
          s.env
        )
    )
    config.ai.mcp
  );

  uniqueEnvs = lib.unique remoteEnvList;

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

  # Bridge an `ai.mcp.<name>` entry to the shape home-manager's `lib.hm.mcp`
  # helpers expect: scalar command plus args list, and env as file-ref
  # submodules (`{ file = path; }`) or literal strings.
  mcpToHm = server: let
    hasCommand = server.command != null && server.command != [];
  in
    {
      command =
        if hasCommand
        then builtins.head server.command
        else null;
      args =
        if hasCommand
        then lib.tail server.command
        else [];
      inherit (server) url headers;
    }
    // lib.optionalAttrs (server.type == "local") {
      env =
        lib.mapAttrs (
          _: v:
            if v.path != null
            then {file = v.path;}
            else v.text
        )
        server.env;
    };

  # Launch command for a local server as an argv list, with file-backed
  # secrets folded into a per-server wrapper script that reads them at
  # startup. Returns null for remote servers.
  mcpLocalCommand = name: server:
    if server.type != "local"
    then null
    else let
      wrapped = lib.hm.mcp.wrapEnvFilesCommand {inherit pkgs name;} (mcpToHm server);
    in
      [wrapped.command] ++ wrapped.args;

  # Normalise an `ai.mcp` server for a consumer: per-server secret wrapping
  # plus home-manager's shared cleanup (enabled/disabled resolution, dropping
  # null/empty values).
  mkMcpServer = {
    name,
    server,
  }:
    lib.hm.mcp.transformMcpServer {
      server = mcpToHm server;
      extraTransforms = [(lib.hm.mcp.wrapEnvFilesCommand {inherit pkgs name;})];
    };

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
      then "mcp__plugin_hm_${builtins.elemAt m 0}__${builtins.elemAt m 1}"
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
