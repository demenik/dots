{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      kotlin-lsp
      ktlint
    ];

    lsp.servers.kotlin_lsp.enable = true;

    plugins = {
      lint.lintersByFt.kotlin = ["ktlint"];

      conform-nvim.settings.formatters_by_ft.kotlin = ["ktlint"];
    };
  };
}
