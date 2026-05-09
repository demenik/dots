{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      rubocop
    ];

    lsp.servers.solargraph.enable = true;

    plugins = {
      lint.lintersByFt.ruby = ["rubocop"];
    };
  };
}
