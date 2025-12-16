require("incline").setup {}

-- vim_current_word
vim.cmd [[
  hi CurrentWord guifg=#cba6f7
  let g:vim_current_word#hightlight_twins = 0
  let g:vim_current_word#excluded_filetypes = ["minifiles", "netrw", "snacks_dashboard"]
]]

local g = vim.g
