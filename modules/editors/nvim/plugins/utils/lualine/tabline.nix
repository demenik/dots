c: let
  get-mode-color =
    # lua
    "
    function()
      local mode_color = {
        n = '${c.base0D}',
        i = '${c.base0B}',

        v = '${c.base0E}',
        [''] = '${c.base0E}',
        V = '${c.base0E}',

        c = '${c.base0E}',
        no = '${c.base08}',

        s = '${c.base09}',
        S = '${c.base09}',
        [''] = '${c.base09}',

        ic = '${c.base0A}',
        R = '${c.base0E}',
        Rv = '${c.base0E}',
        cv = '${c.base08}',
        ce = '${c.base08}',
        r = '${c.base0C}',
        rm = '${c.base0C}',
        ['r?'] = '${c.base0C}',
        ['!'] = '${c.base08}',
        t = '${c.base0F}',
      }
      return { fg = mode_color[vim.fn.mode()] }
    end
  ";
in {
  lualine_c = import ./section-left.nix c get-mode-color;
  lualine_x = import ./section-right.nix c get-mode-color;
}
