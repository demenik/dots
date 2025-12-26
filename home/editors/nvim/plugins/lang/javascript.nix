{pkgs, ...}: {
  extraPlugins = with pkgs.vimPlugins; [
    template-string-nvim
  ];

  extraConfig =
    # lua
    ''
      require("template-string").setup {
        remove_template_string = true,
        restore_quotes = {
          normal = [["]],
          jsx = [["]],
        },
      }
    '';
}
