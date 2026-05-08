{pkgs, ...}: {
  programs.nixvim = {
    extraPackages = with pkgs; [
      cppcheck
      clang-tools
      cmake-format
      cmake-lint
    ];

    plugins = {
      lsp.servers = {
        clangd.enable = true;
        cmake.enable = true;
      };

      lint.lintersByFt = {
        cpp = ["cppcheck"];
        cmake = ["cmakelint"];
      };

      conform-nvim.settings.formatters_by_ft = {
        c = ["clang_format"];
        cpp = ["clang_format"];
        cmake = ["cmake_format"];
      };
    };
  };
}
