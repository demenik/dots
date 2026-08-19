{
  lib,
  config,
  ...
}: let
  enabledLangs = lib.filterAttrs (name: info: info.enable) config.lang.meta;
  allPackages = lib.foldl' (acc: info: acc // info.packages) {} (lib.attrValues enabledLangs);
in {
  imports = [
    ./docs
    ./java.nix
    ./lua.nix
    ./python.nix
    ./qml.nix
    ./rust.nix
    ./web.nix
  ];

  programs.nixvim = {
    lsp.servers = lib.foldl' (
      acc: info:
        lib.foldl' (
          acc2: lspName:
            acc2
            // {
              "${lspName}" =
                {enable = true;}
                // lib.optionalAttrs (info.packages ? ${lspName}) {
                  package = info.packages.${lspName};
                };
            }
        )
        acc
        info.lsps
    ) {} (lib.attrValues enabledLangs);

    plugins = {
      lint = {
        lintersByFt = lib.foldl' (
          acc: info:
            lib.recursiveUpdate acc info.linters
        ) {} (lib.attrValues enabledLangs);

        autoInstall = {
          enable = true;
          overrides = allPackages;
        };
      };

      conform-nvim = {
        settings.formatters_by_ft = lib.foldl' (
          acc: info:
            lib.recursiveUpdate acc info.formatters
        ) {} (lib.attrValues enabledLangs);

        autoInstall = {
          enable = true;
          overrides = allPackages;
        };
      };
    };
  };
}
