{lib, ...}: {
  name = "lang-lua";

  moduleOptions = with lib; {
    lang.lua = {
      enable = mkEnableOption "Enable Lua language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add Lua lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.lua;
    packages = {
      inherit (pkgs) selene stylua;
      lua_ls = pkgs.lua-language-server;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.lua = {
        enable = true;
        inherit packages;
        lsps = ["lua_ls"];
        linters = {
          lua = ["selene"];
        };
        formatters = {
          lua = ["stylua"];
        };
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "lua-lsp" = "${pkgs.claude-plugins}/plugins/lua-lsp";
      };
    };
}
