{lib, ...}: {
  name = "lang-nix";

  moduleOptions = with lib; {
    lang.nix = {
      enable = mkEnableOption "Enable Nix language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Nix lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.nix;
    packages = {
      inherit (pkgs) nixd statix alejandra nixfmt;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.nix = {
        enable = true;
        inherit packages;
        lsps = ["nixd"];
        linters = {
          nix = ["statix"];
        };
        formatters = {
          nix = ["alejandra" "injected"];
        };
      };
    };
}
