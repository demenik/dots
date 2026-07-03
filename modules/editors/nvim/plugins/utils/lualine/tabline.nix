c: let
  get-mode-color =
    # lua
    "
    function()
      local cp = require('catppuccin.palettes').get_palette()
      local mode_color = {
        n = cp.blue,
        i = cp.green,

        v = cp.mauve,
        [''] = cp.mauve,
        V = cp.mauve,

        c = cp.mauve,
        no = cp.red,

        s = cp.peach,
        S = cp.peach,
        [''] = cp.peach,

        ic = cp.yellow,
        R = cp.mauve,
        Rv = cp.mauve,
        cv = cp.red,
        ce = cp.red,
        r = cp.teal,
        rm = cp.teal,
        ['r?'] = cp.teal,
        ['!'] = cp.red,
        t = cp.flamingo,
      }
      return { fg = mode_color[vim.fn.mode()] }
    end
  ";
in {
  lualine_c = import ./section-left.nix c get-mode-color;
  lualine_x = import ./section-right.nix c get-mode-color;
}
