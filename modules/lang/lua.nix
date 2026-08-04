{lib, ...}: {
  name = "lang-lua";

  moduleOptions = with lib; {
    lang.lua.enable = mkEnableOption "Enable Lua language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.lua.enable {
      home.packages = with pkgs; [
        selene
        stylua
        lua-language-server
      ];

      lang.meta.lua = {
        enable = true;
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
