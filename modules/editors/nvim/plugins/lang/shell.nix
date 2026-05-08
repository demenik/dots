{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      shfmt
      shellcheck
    ];

    plugins = {
      lsp.servers.bashls.enable = true;

      lint.lintersByFt.bash = ["bash"];

      conform-nvim.settings.formatters_by_ft.sh = ["shellcheck" "shfmt"];
    };
  };
}
