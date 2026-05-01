{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      shfmt
      shellcheck
      stylua
      alejandra
      nixfmt

      prettier
      prettierd

      sqruff

      yamlfmt

      black

      go
      gotools
      gdtoolkit_4

      rustfmt
      clang-tools
      csharpier
      cmake-format

      kdePackages.qtdeclarative # qmlformat

      ktlint
    ];

    plugins.conform-nvim = {
      enable = true;

      settings = {
        notifyOnError = true;

        formatters_by_ft = let
          prettier = {
            __unkeyed-1 = "prettierd";
            __unkeyed-2 = "prettier";
            timeout_ms = 2000;
            stop_after_first = true;
          };
        in {
          sh = ["shellcheck" "shfmt"];
          lua = ["stylua"];
          nix = ["alejandra" "injected"];

          html = prettier;
          css = prettier;
          javascript = prettier;
          typescript = prettier;
          javascriptreact = prettier;
          typescriptreact = prettier;
          astro = prettier;

          sql = ["sqruff"];

          json = prettier;
          yaml = ["yamlfmt"];

          python = ["black"];

          go = ["goimports" "gofmt"];
          java = []; # use jdtls
          kotlin = ["ktlint"];
          gdscript = ["gdformat"];

          rust = ["rustfmt"];
          c = ["clang_format"];
          cmake = ["cmake_format"];
          cpp = ["clang_format"];
          cs = ["csharpier"];

          qml = ["qmlformat"];
          qmljs = ["qmlformat"];

          # "_" = ["trim_whitespace" "trim_newlines"];
        };

        format_after_save = {
          lsp_fallback = true;
        };
      };
    };

    extraConfigLua = ''
      vim.g.slow_format_filetypes = {}
    '';
  };
}
