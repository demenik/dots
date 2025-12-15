{pkgs, ...}: {
  extraPackages = with pkgs; [
    shfmt
    shellcheck
    stylua
    alejandra

    prettier
    prettierd

    sqruff

    yamlfmt

    black

    go
    gotools
    google-java-format
    ktlint
    gdtoolkit_4

    rustfmt
    clang-tools
    cmake-format

    kdePackages.qtdeclarative # qmlformat
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
        nix = ["alejandra"];

        html = prettier;
        css = prettier;
        javascript = prettier;
        typescript = prettier;
        javascriptreact = prettier;
        typescriptreact = prettier;

        sql = ["sqruff"];

        json = prettier;
        yaml = ["yamlfmt"];

        python = ["black"];

        go = ["goimports" "gofmt"];
        java = ["google-java-format"];
        kotlin = ["ktlint"];
        gdscript = ["gdformat"];

        rust = ["rustfmt"];
        c = ["clang_format"];
        cmake = ["cmake_format"];
        cpp = ["clang_format"];

        qml = ["qmlformat"];
        qmljs = ["qmlformat"];

        "_" = ["trim_whitespace" "trim_newlines"];
      };

      formatters = {
        prettier = {
          command = "prettier";
          prepend_args = ["-w"];
        };
        prettierd = {
          command = "prettierd";
          prepend_args = ["-w"];
        };
      };

      format_on_save =
        # lua
        ''
          function(bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if vim.g.slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            local function on_format(err)
              if err and err:match("timeout$") then
                slow_format_filetypes[vim.bo[bufnr].filetype] = true
              end
            end

            return { timeout_ms = 200, lsp_fallback = true }, on_format
          end
        '';

      format_after_save =
        # lua
        ''
          function (bufnr)
            if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
              return
            end

            if not vim.g.slow_format_filetypes[vim.bo[bufnr].filetype] then
              return
            end

            return { lsp_fallback = true }
          end
        '';
    };
  };

  extraConfigLua = ''
    vim.g.slow_format_filetypes = {};
  '';
}
