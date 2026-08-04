{lib, ...}: {
  name = "lang-csharp";

  moduleOptions = with lib; {
    lang.csharp.enable = mkEnableOption "Enable C# language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.csharp.enable {
      home.packages = with pkgs; [
        csharpier
        csharp-ls
        (dotnetCorePackages.combinePackages [
          dotnetCorePackages.sdk_8_0
          dotnetCorePackages.sdk_10_0
        ])
      ];

      lang.meta.csharp = {
        enable = true;
        lsps = ["csharp_ls"];
        linters = {};
        formatters = {
          cs = ["csharpier"];
        };
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "csharp-lsp" = "${pkgs.claude-plugins}/plugins/csharp-lsp";
      };
    };
}
