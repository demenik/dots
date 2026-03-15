{pkgs, ...}: {
  programs.nixvim = {
    plugins = {
      treesitter = {
        enable = true;
        folding.enable = false;
        nixGrammars = true;
        nixvimInjections = true;
        settings = (import ./settings.nix) pkgs;
      };

      ts-autotag.enable = true;
      treesitter-textobjects = import ./textobjects.nix;
    };

    extraConfigLua = ''
      _G.smart_indent_wrapper = function()
        local bufnr = vim.api.nvim_get_current_buf()
        local lang = vim.treesitter.language.get_lang(vim.bo[bufnr].filetype) or vim.bo[bufnr].filetype

        local has_query = pcall(vim.treesitter.query.get, lang, "indents")
        local query = has_query and vim.treesitter.query.get(lang, "indents")

        if query then
          return vim.treesitter.indent()
        else
          return vim.fn.cindent(vim.v.lnum)
        end
      end
    '';
    autoCmd = [
      {
        event = "FileType";
        pattern = ["cs" "kotlin"];
        command = "setlocal indentexpr=v:lua.smart_indent_wrapper()";
      }
    ];
    opts = {
      smartindent = true;
      cindent = true;
    };
  };
}
