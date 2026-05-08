{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      statix
      alejandra
      nixfmt
    ];

    plugins = {
      lsp.servers.nixd.enable = true;

      lint.lintersByFt.nix = ["statix"];

      conform-nvim.settings.formatters_by_ft.nix = ["alejandra" "injected"];
    };
  };
}
