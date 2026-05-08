{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      rubocop
    ];

    plugins = {
      lsp.servers.solargraph.enable = true;

      lint.lintersByFt.ruby = ["rubocop"];
    };
  };
}
