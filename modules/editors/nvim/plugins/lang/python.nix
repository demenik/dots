{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      ruff
      black
      python312Packages.flake8
    ];

    lsp.servers.pylyzer.enable = true;

    plugins = {
      lint.lintersByFt.python = ["ruff"];

      conform-nvim.settings.formatters_by_ft.python = ["black"];
    };
  };
}
