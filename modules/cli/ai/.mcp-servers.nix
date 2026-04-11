{
  lib,
  config,
  ...
}: let
  servers = {
    gitmcp = {
      url = "https://gitmcp.io/docs";
    };
    context7 = {
      url = "https://mcp.context7.com/mcp";
      secretName = "mcp-context7";
      authHeader = "CONTEXT7_API_KEY";
      envVar = "CONTEXT7_API_KEY";
    };
  };

  isServerValid = server:
    if server ? secretName && server.secretName != null
    then config.sops.secrets ? ${server.secretName}
    else true;

  activeServers = lib.filterAttrs (name: isServerValid) servers;

  mcpKeys = lib.mapAttrs' (
    name: server:
      lib.nameValuePair server.envVar config.sops.secrets.${server.secretName}.path
  ) (lib.filterAttrs (name: server: server ? secretName && server.secretName != null && server ? envVar) activeServers);
in {
  wrapperArgs =
    lib.mapAttrsToList
    (envName: path: "--run 'export ${envName}=$(cat \"${path}\")'")
    mcpKeys;

  servers = activeServers;
}
