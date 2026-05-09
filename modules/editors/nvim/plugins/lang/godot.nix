{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      gdtoolkit_4
    ];

    lsp.servers.gdscript.enable = true;

    plugins = {
      conform-nvim.settings.formatters_by_ft.gdscript = ["gdformat"];
    };
  };
}
