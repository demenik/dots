{lib, ...}: {
  name = "lang-cpp";

  moduleOptions = with lib; {
    lang.cpp.enable = mkEnableOption "Enable C/C++ language tools";
  };

  home = {
    pkgs,
    lib,
    config,
    ...
  }:
    lib.mkIf config.lang.cpp.enable {
      home.packages = with pkgs; [
        cppcheck
        clang-tools
        cmake-format
        cmake-lint
        cmake-language-server
      ];

      lang.meta.cpp = {
        enable = true;
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
