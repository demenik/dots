{
  lib,
  config,
  ...
}: let
  enabledLangs = lib.filterAttrs (name: info: info.enable) config.lang.meta;
in {
  imports = [
    ./docs
    ./java.nix
    ./lua.nix
    ./python.nix
    ./rust.nix
    ./web.nix
  ];

  programs.nixvim = {
    lsp.servers = lib.foldl' (
      acc: info:
        lib.foldl' (
          acc2: lspName:
            acc2 // {"${lspName}".enable = true;}
        )
        acc
        info.lsps
    ) {} (lib.attrValues enabledLangs);

    plugins = {
      lint.lintersByFt = lib.foldl' (
        acc: info:
          lib.recursiveUpdate acc info.linters
      ) {} (lib.attrValues enabledLangs);

      conform-nvim.settings.formatters_by_ft = lib.foldl' (
        acc: info:
          lib.recursiveUpdate acc info.formatters
      ) {} (lib.attrValues enabledLangs);
    };
  };
}
