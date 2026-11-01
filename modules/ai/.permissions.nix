{
  home = {lib, ...}: let
    jsInstallers = ["bun" "npm" "pnpm" "yarn"];
    jsRunners = ["bunx" "npx" "pnpm exec" "yarn"];

    jsInstallerCmds = ["install" "run" "test"];
    jsRunnerTools = ["prettier"];

    mergeCommands = lib.zipAttrsWith (_: rules: {allow = lib.concatMap (r: r.allow) rules;});
    withSubcommands = cmds: subs: lib.concatMap (c: map (s: "${c} ${s}") subs) cmds;
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

          # Forge CLIs (read-only)
          (mergeCommands [
            (lib.genAttrs ["gh" "glab" "fj"] (_: {allow = ["issue view" "release list" "release view" "repo view"];}))
            (lib.genAttrs ["gh" "glab"] (_: {allow = ["issue list" "repo list" "label list" "auth status"];}))
            (lib.genAttrs ["gh" "fj"] (_: {allow = ["pr view" "pr status"];}))
            (lib.genAttrs ["fj" "tea"] (_: {allow = ["whoami"];}))
            {
              gh.allow = ["status" "search" "pr list" "pr diff" "pr checks" "issue status" "run list" "run view" "run watch" "workflow list" "workflow view"];
              glab.allow = ["mr list" "mr view" "mr diff" "mr issues" "ci list" "ci get" "ci status" "ci trace" "ci lint" "label get"];
              fj.allow = ["pr search" "issue search" "issue templates" "repo readme" "actions tasks" "auth list" "user view" "user search" "wiki contents" "wiki view"];
              tea.allow = lib.concatLists [
                (withSubcommands ["issues" "issue" "i" "pulls" "pull" "pr" "labels" "label" "milestones" "milestone" "ms" "releases" "release" "r" "branches" "branch" "b"] ["list" "ls"])
                (withSubcommands ["pulls" "pull" "pr"] ["review-comments" "rc"])
                (withSubcommands ["logins" "login"] ["list" "ls" "status"])
              ];
            }
          ])
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
