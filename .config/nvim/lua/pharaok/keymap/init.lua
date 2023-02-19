local remap = require("pharaok.keymap.remap")

vim.g.mapleader = " "

remap("n", "<C-h>", function()
  vim.cmd("wincmd h")
end)
remap("n", "<C-j>", function()
  vim.cmd("wincmd j")
end)
remap("n", "<C-k>", function()
  vim.cmd("wincmd k")
end)
remap("n", "<C-l>", function()
  vim.cmd("wincmd l")
end)

remap("t", "<Esc>", "<C-\\><C-n>")

remap("n", "<Esc>", function()
  vim.cmd("nohlsearch")
end)
remap("x", "<Leader>p", '"_dP')
