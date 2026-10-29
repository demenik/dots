{
  home = {
    ai.mcp.gitmcp = {
      type = "remote";
      url = "https://gitmcp.io/docs";
    };

    ai.permissions.mcp.allow = map (t: "gitmcp_${t}") [
      "match_common_libs_owner_repo_mapping"
      "fetch_generic_documentation"
      "search_generic_documentation"
      "search_generic_code"
      "fetch_generic_url_content"
    ];
  };
}
