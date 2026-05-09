{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      shfmt
      shellcheck
    ];

    lsp.servers.bashls.enable = true;

    plugins = {
      lint.lintersByFt.bash = ["bash"];

      conform-nvim.settings.formatters_by_ft.sh = ["shellcheck" "shfmt"];
    };
  };
}
