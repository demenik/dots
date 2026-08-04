{lib, ...}: {
  name = "lang-csharp";

  moduleOptions = with lib; {
    lang.csharp = {
      enable = mkEnableOption "Enable C# language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add C# lsp/formatter tools to PATH (the .NET SDK is always added)";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.csharp;
    packages = {
      inherit (pkgs) csharpier;
      csharp_ls = pkgs.csharp-ls;
    };
  in
    lib.mkIf cfg.enable {
      home.packages =
        [
          (pkgs.dotnetCorePackages.combinePackages [
            pkgs.dotnetCorePackages.sdk_8_0
            pkgs.dotnetCorePackages.sdk_10_0
          ])
        ]
        ++ lib.optionals cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.csharp = {
        enable = true;
        inherit packages;
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
