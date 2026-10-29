{
  home = {lib, ...}: let
    jsInstallers = ["bun" "npm" "pnpm" "yarn"];
    jsRunners = ["bunx" "npx" "pnpm exec" "yarn"];

    jsInstallerCmds = ["install" "run" "test"];
    jsRunnerTools = ["prettier"];

    mergeCommands = lib.zipAttrsWith (_: rules: {allow = lib.concatMap (r: r.allow) rules;});
  in {
    ai.permissions = {
      bash = {
        commands = lib.mkMerge [
          (mergeCommands [
            (lib.genAttrs jsInstallers (_: {allow = jsInstallerCmds;}))
            (lib.genAttrs jsRunners (_: {allow = jsRunnerTools;}))
          ])
          {
            bun.allow = ["update" "add"];
            npm.allow = ["update"];
            pnpm.allow = ["update" "add"];
            yarn.allow = ["upgrade" "add"];
          }

          {
            nix.allow = ["eval"];
            git.allow = ["log" "diff" "status" "check-ignore" "show" "fetch" "grep" "reflog" "ls-tree" "rev-parse"];
            cargo.allow = ["build" "check" "test" "fmt" "clippy"];
          }
        ];

        allow = [
          "echo *"
          "ls *"
          "grep *"
          "rg *"
          "fd *"
          "head *"
          "tail *"
          "sort *"
        ];
      };

      read = {
        allow = ["*" "*.env.example"];
        ask = ["*.env" "*.env.*"];
      };

      edit.allow = ["*"];

      webFetch.allow = map (d: "domain:${d}") [
        "github.com"
        "raw.githubusercontent.com"
        "docs.rs"
        "nixos.org"
        "search.nixos.org"
        "wiki.nixos.org"
        "nix.dev"
        "noogle.dev"
        "developer.mozilla.org"
        "pypi.org"
        "www.npmjs.com"
      ];
      webSearch.allow = ["*"];

      mcp.allow = [
        "context7_resolve-library-id"
        "context7_query-docs"

        "gitmcp_match_common_libs_owner_repo_mapping"
        "gitmcp_fetch_generic_documentation"
        "gitmcp_search_generic_documentation"
        "gitmcp_search_generic_code"
        "gitmcp_fetch_generic_url_content"
      ]
      ++ map (t: "n8n_${t}") [
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

      other = {
        list.allow = ["*"];
        glob.allow = ["*"];
        grep.allow = ["*"];
        codesearch.allow = ["*"];
        todoread.allow = ["*"];
        todowrite.allow = ["*"];
      };
    };
  };
}
