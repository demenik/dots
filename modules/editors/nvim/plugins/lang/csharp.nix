{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      csharpier
      (dotnetCorePackages.combinePackages [
        dotnetCorePackages.sdk_8_0
        dotnetCorePackages.sdk_10_0
      ])
    ];

    lsp.servers.csharp_ls.enable = true;

    plugins = {
      conform-nvim.settings.formatters_by_ft.cs = ["csharpier"];
    };
  };
}
