{lib, ...}: {
  name = "lang-cpp";

  moduleOptions = with lib; {
    lang.cpp = {
      enable = mkEnableOption "Enable C/C++ language tools";
      onPath = mkOption {
        type = types.bool;
        default = true;
        description = "Add C/C++ lsp/linter/formatter tools to PATH";
      };
    };
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }: let
    cfg = config.lang.cpp;
    packages = {
      inherit (pkgs) cppcheck;
      clangd = pkgs.clang-tools;
      clang_format = pkgs.clang-tools;
      cmake = pkgs.cmake-language-server;
      cmake_format = pkgs.cmake-format;
      cmakelint = pkgs.cmake-lint;
    };
  in
    lib.mkIf cfg.enable {
      home.packages = lib.mkIf cfg.onPath (lib.unique (builtins.attrValues packages));

      lang.meta.cpp = {
        enable = true;
        inherit packages;
        lsps = ["clangd" "cmake"];
        linters = {
          cpp = ["cppcheck"];
          cmake = ["cmakelint"];
        };
        formatters = {
          c = ["clang_format"];
          cpp = ["clang_format"];
          cmake = ["cmake_format"];
        };
      };

      programs.claude-code.plugins = lib.mkIf config.programs.claude-code.enable {
        "clangd-lsp" = "${pkgs.claude-plugins}/plugins/clangd-lsp";
      };
    };
}
