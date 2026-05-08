{pkgs, ...}: let
  prettier_config = (import ../formatting/prettier.nix).prettier;
in {
  programs.nixvim = {
    extraPackages = with pkgs; [
      yamlfmt
      yamllint
    ];

    plugins = {
      schemastore.enable = true;

      lsp.servers = {
        taplo.enable = true;
        jsonls = {
          enable = true;
          config.json.validate.enable = true;
        };
        yamlls = {
          enable = true;
          config.yaml.schemaStore.enable = false;
        };
        lemminx.enable = true;
      };

      lint.lintersByFt = {
        yaml = ["yamllint"];
      };

      conform-nvim.settings.formatters_by_ft = {
        json = prettier_config;
        yaml = ["yamlfmt"];
      };
    };
  };
}
