{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      ltex-ls-plus
    ];

    lsp.servers.ltex_plus = {
      enable = false;
      config = {
        filetypes = [
          "asciidoc" "bib" "context" "gitcommit" "html" "markdown" "org" "pandoc"
          "plaintex" "quarto" "mail" "mdx" "rmd" "rnoweb" "rst" "tex" "text"
          "typst" "xhtml" "c" "cpp" "clojure" "dart" "elixir" "elm" "erlang"
          "fsharp" "go" "groovy" "haskell" "java" "javascript" "javascriptreact"
          "julia" "kotlin" "lisp" "lua" "matlab" "perl" "perl6" "php" "puppet"
          "python" "r" "ruby" "rust" "scala" "sql" "swift" "typescript" "typescriptreact"
          "verilog" "vb"
        ];
        settings.ltex = {
          enabled = [
            "asciidoc" "bib" "context" "gitcommit" "html" "markdown" "org" "pandoc"
            "plaintex" "quarto" "mail" "mdx" "rmd" "rnoweb" "rst" "tex" "latex" "text"
            "typst" "xhtml" "c" "cpp" "clojure" "dart" "elixier" "elm" "erlang"
            "fsharp" "go" "groovy" "haskell" "java" "javascript" "javascriptreact"
            "julia" "kotlin" "lisp" "lua" "matlab" "perl" "perl6" "php" "puppet"
            "python" "r" "ruby" "rust" "scala" "sql" "swift" "typescript" "typescriptreact"
            "verilog" "vb"
          ];
          languageToolHttpServerUri = "https://languagetool.demenik.dev";
          language = "en-US";
          additionalRules.motherTongue = "de-DE";
          dictionary = {
            en-US = [ "ags" "fzf" "Gitsigns" "Vimtex" "dap" "neotest" ];
          };
        };
      };
    };
  };
}
