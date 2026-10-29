{
  secrets.mcp-n8n = {
    usedBy = "hm";
    required = false;
    description = "n8n MCP Server API Key";
  };

  home = {
    lib,
    config,
    ...
  }:
    lib.mkIf (config.sops.secrets ? mcp-n8n) {
      ai.mcp.n8n = {
        type = "remote";
        url = "https://n8n.demenik.dev/mcp-server/http";
        env.N8N_MCP_API_KEY.path = config.sops.secrets.mcp-n8n.path;
        headers.Authorization = "Bearer $N8N_MCP_API_KEY";
      };

      ai.permissions.mcp.allow = map (t: "n8n_${t}") [
        "get_user_preferences"
        "get_workflow_sdk_reference"
        "get_workflow_best_practices"
        "get_agent_builder_reference"
        "get_node_types"
        "search_nodes"
        "discover_agent_assets"
        "list_n8n_gateway_services"

        "search_projects"
        "search_folders"
        "search_workflows"
        "list_workflow_tags"
        "get_workflow_details"
        "get_workflow_history"
        "get_workflow_version"
        "get_workflow_versions_diff"
        "search_workflow_executions"
        "get_workflow_execution"

        "search_agents"
        "get_agent"
        "list_agent_versions"

        "search_data_tables"
        "get_data_table_rows"

        "validate_workflow"
        "validate_node_config"
        "validate_agent"
      ];
    };
}
