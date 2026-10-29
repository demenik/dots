{
  secrets.mcp-context7 = {
    usedBy = "hm";
    required = false;
    description = "Context7 API Key";
  };

  home = {
    lib,
    config,
    ...
  }:
    lib.mkIf (config.sops.secrets ? mcp-context7) {
      ai.mcp.context7 = {
        type = "remote";
        url = "https://mcp.context7.com/mcp";
        env.CONTEXT7_API_KEY.path = config.sops.secrets.mcp-context7.path;
        headers.CONTEXT7_API_KEY = "$CONTEXT7_API_KEY";
      };

      ai.permissions.mcp.allow = map (t: "context7_${t}") [
        "resolve-library-id"
        "query-docs"
      ];
    };
}
