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
