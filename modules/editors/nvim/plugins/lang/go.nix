{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      golangci-lint
      go
      gotools
    ];

    plugins = {
      lsp.servers.gopls.enable = true;

      lint.lintersByFt.go = ["golangcilint"];

      conform-nvim.settings.formatters_by_ft.go = ["goimports" "gofmt"];
    };
  };
}
