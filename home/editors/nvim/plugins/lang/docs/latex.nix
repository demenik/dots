{pkgs, ...}: {
  extraPackages = with pkgs; [sioyek tectonic];

  plugins.vimtex = {
    enable = true;
    settings = {
      view_method = "sioyek";
      quickfix_mode = 0; # supress error reporting on save and build
      mappings_enable = 0; # ignore mappings
      indent_enabled = 0; # auto indent
      # tex_flavor = "latex"; # how to read tex files
      # tex_indent_items = 0; # turn off enumerate indent
      # tex_indent_brace = 0; # turn off brace indent
      compiler_method = "tectonic"; # tex compiler
      log_ignore = [
        "Underfull"
        "Overfull"
        "specifier changed to"
        "Token not allowed in a PDF string"
      ];
    };
  };

  plugins.which-key.settings.spec = [
    {
      __unkeyed-1 = "<leader>L";
      group = "Latex";
      icon = " ";
    }
  ];
  keymaps = let
    latex = key: action: {
      key = "<leader>L${key}";
      action = "<cmd>Vimtex${action}<cr>";
      options.desc = action;
    };
  in [
    (latex "v" "View")
    (latex "e" "Errors")
    (latex "r" "Reload")
    (latex "c" "Compile")
  ];
}
