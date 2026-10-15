{lib, ...}: {
  name = "lang-haskell";

  moduleOptions = with lib; {
    lang.haskell = {
      enable = mkEnableOption "Enable Haskell language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Haskell lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.haskell;
    packages = {
      inherit (pkgs) haskell-language-server hlint fourmolu;
      cabal_fmt = pkgs.haskellPackages.cabal-fmt;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.haskell = {
        enable = true;
        inherit packages;
        lsps = ["hls"];
        linters = {
          haskell = ["hlint"];
        };
        formatters = {
          haskell = ["fourmolu"];
          cabal = ["cabal_fmt"];
        };
      };
    };
}
