{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      qt6.qtdeclarative
    ];

    lsp.servers.qmlls.enable = true;

    plugins = {
      lint.lintersByFt.qml = ["qmllint"];

      conform-nvim.settings.formatters_by_ft.qml = ["qmlformat"];
    };
  };
}
