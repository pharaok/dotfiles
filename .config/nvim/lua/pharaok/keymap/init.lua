local remap = require("pharaok.keymap.remap")

vim.g.mapleader = " "
vim.g.maplocalleader = " "

remap("n", "<C-h>", "<Cmd>wincmd h<CR>")
remap("n", "<C-j>", "<Cmd>wincmd j<CR>")
remap("n", "<C-k>", "<Cmd>wincmd k<CR>")
remap("n", "<C-l>", "<Cmd>wincmd l<CR>")

remap("n", "[c", function()
  return "<Cmd>" .. vim.v.count .. "cprev<CR>"
end, { expr = true })
remap("n", "]c", function()
  return "<Cmd>" .. vim.v.count .. "cnext<CR>"
end, { expr = true })

remap("t", "<Esc>", "<C-\\><C-n>")

remap("n", "<Esc>", function()
  vim.cmd("nohlsearch")
end)

remap("x", "<Leader>y", '"+y')
remap("x", "<Leader>p", '"_dP')
