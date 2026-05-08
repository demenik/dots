{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      gdtoolkit_4
    ];

    plugins = {
      lsp.servers.gdscript.enable = true;

      conform-nvim.settings.formatters_by_ft.gdscript = ["gdformat"];
    };
  };
}
