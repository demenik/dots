{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      qt6.qtdeclarative
    ];

    lsp.servers.qmlls.enable = true;
    extraConfigLuaPre = ''
      local import_path = os.getenv("QML_IMPORT_PATH")
      if import_path then
        local import_paths = {}
        for path in string.gmatch(import_path, "[^:]+") do
          table.insert(import_paths, path)
        end

        local cmd = { "qmlls" }
        for _, path in ipairs(import_paths) do
          table.insert(cmd, "-I")
          table.insert(cmd, path)
        end

        if vim.lsp and vim.lsp.config then
          local qmlls_config = vim.lsp.config["qmlls"] or {}
          qmlls_config.cmd = cmd
          vim.lsp.config("qmlls", qmlls_config)
        end
      end
    '';

    plugins = {
      lint.lintersByFt.qml = ["qmllint"];

      conform-nvim.settings.formatters_by_ft.qml = ["qmlformat"];
    };
  };
}
