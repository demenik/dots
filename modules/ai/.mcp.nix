{
  secrets = {
    mcp-context7 = {
      usedBy = "hm";
      required = false;
      description = "Context7 API Key";
    };
    mcp-n8n = {
      usedBy = "hm";
      required = false;
      description = "n8n MCP Server API Key";
    };
  };

  home = {
    lib,
    config,
    ...
  }: {
    ai.mcp = lib.mkMerge [
      {
        gitmcp = {
          type = "remote";
          url = "https://gitmcp.io/docs";
        };
      }
      (lib.mkIf (config.sops.secrets ? mcp-context7) {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          env.CONTEXT7_API_KEY.path = config.sops.secrets.mcp-context7.path;
          headers.CONTEXT7_API_KEY = "$CONTEXT7_API_KEY";
        };
      })
      (lib.mkIf (config.sops.secrets ? mcp-n8n) {
        n8n = {
          type = "remote";
          url = "https://n8n.demenik.dev/mcp-server/http";
          env.N8N_MCP_API_KEY.path = config.sops.secrets.mcp-n8n.path;
          headers.Authorization = "Bearer $N8N_MCP_API_KEY";
        };
      })
    ];
  };
}
