if not vim.g.neovide then
  return
end

local remap = require("pharaok.keymap.remap")

vim.g.transparent = false
vim.o.guifont = "FiraCode Nerd Font"
vim.g.neovide_scale_factor = 1.0

local change_scale_factor = function(delta)
  vim.g.neovide_scale_factor = vim.g.neovide_scale_factor * delta
end

local scale_factor = 1.1
remap("n", "<C-=>", function()
  change_scale_factor(scale_factor)
end)

remap("n", "<C-->", function()
  change_scale_factor(1 / scale_factor)
end)
