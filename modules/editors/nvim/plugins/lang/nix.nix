{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      statix
      alejandra
      nixfmt
    ];

    lsp.servers.nixd.enable = true;

    plugins = {
      lint.lintersByFt.nix = ["statix"];

      conform-nvim.settings.formatters_by_ft.nix = ["alejandra" "injected"];
    };
  };
}
