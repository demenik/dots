{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      golangci-lint
      go
      gotools
    ];

    lsp.servers.gopls.enable = true;

    plugins = {
      lint.lintersByFt.go = ["golangcilint"];

      conform-nvim.settings.formatters_by_ft.go = ["goimports" "gofmt"];
    };
  };
}
