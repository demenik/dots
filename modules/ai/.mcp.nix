{
  secrets = {
    mcp-context7 = {
      usedBy = "hm";
      required = false;
      description = "Context7 API Key";
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
        marimo = {
          type = "remote";
          url = "http://localhost:2718/mcp/server";
        };
      }
      (lib.mkIf (config.sops.secrets ? mcp-context7) {
        context7 = {
          type = "remote";
          url = "https://mcp.context7.com/mcp";
          env = {
            CONTEXT7_API_KEY.path = config.sops.secrets.mcp-context7.path;
          };
          headers = {
            CONTEXT7_API_KEY = "$CONTEXT7_API_KEY";
          };
        };
      })
    ];
  };
}
