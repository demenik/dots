{pkgs, ...}: {
  extraPackages = with pkgs; [sioyek tectonic];

  plugins.vimtex.enable = true;

  extraConfigLua = ''
    vim.g["vimtex_view_method"] = "sioyek"
    vim.g["vimtex_quickfix_mode"] = 0              -- supress error reporting on save and build
    vim.g["vimtex_mappings_enable"] = 0            -- ignore mappings
    vim.g["vimtex_indent_enabled"] = 0             -- auto indent
    vim.g["tex_flavor"] = "latex"                  -- how to read tex files
    vim.g["tex_indent_items"] = 0                  -- turn off enumerate indent
    vim.g["tex_indent_brace"] = 0                  -- turn off brace indent
    vim.g["vimtex_compiler_method"] = "tectonic"   -- tex compiler
    vim.g["vimtex_log_ignore"] = ({                -- Error supression:
      "Underfull",
      "Overfull",
      "specifier changed to",
      "Token not allowed in a PDF string",
    })
  '';
}
