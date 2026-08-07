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
          "find *"
          "fd *"
          "head *"
          "tail *"
          "xargs *"
          "sort *"
        ];
      };

      read = {
        allow = ["*" "*.env.example"];
        ask = ["*.env" "*.env.*"];
      };

      edit.allow = ["*"];

      webFetch.allow = ["*"];
      webSearch.allow = ["*"];

      mcp.allow = [
        "context7_resolve-library-id"
        "context7_query-docs"

        "gitmcp_match_common_libs_owner_repo_mapping"
        "gitmcp_fetch_generic_documentation"
        "gitmcp_search_generic_documentation"
        "gitmcp_search_generic_code"
        "gitmcp_fetch_generic_url_content"
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
