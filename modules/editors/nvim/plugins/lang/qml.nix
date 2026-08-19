{
  lib,
  config,
  ...
}: {
  programs.nixvim = lib.mkIf config.lang.qml.enable {
    plugins.lint.customLinters.qmllint = {
      cmd = "qmllint";
      args = ["--json" "-"];
      stdin = false;
      append_fname = true;
      ignore_exitcode = true;

      parser =
        # lua
        ''
          function(output, bufnr)
            local diagnostics = {}
            local ok, decoded = pcall(vim.json.decode, output)
            if not ok or not decoded or not decoded.files then
              return diagnostics
            end

            local severities = {
              error = vim.diagnostic.severity.ERROR,
              warning = vim.diagnostic.severity.WARN,
              info = vim.diagnostic.severity.INFO,
            }

            for _, file in ipairs(decoded.files) do
              for _, warning in ipairs(file.warnings or {}) do
                table.insert(diagnostics, {
                  lnum = warning.line - 1,
                  col = warning.column - 1,
                  end_lnum = warning.line - 1,
                  end_col = warning.column - 1 + (warning.length or 0),
                  severity = severities[warning.type] or vim.diagnostic.severity.WARN,
                  message = warning.message,
                  source = "qmllint",
                  code = warning.id,
                })
              end
            end

            return diagnostics
          end
        '';
    };
  };
}
