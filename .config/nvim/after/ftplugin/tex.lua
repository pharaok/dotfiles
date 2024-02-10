local remap = require("pharaok.keymap.remap")
local util = require("pharaok.util")

remap("v", "<Leader>s", function()
  vim.fn.setreg("9", vim.fn.py3eval(("util.sympy_solve_latex(r'%s', 'x')"):format(util.get_visual())))
end)
