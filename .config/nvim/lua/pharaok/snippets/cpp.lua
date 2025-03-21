local str_split_lines = require("pharaok.util").str_split_lines

local file = io.open("/home/pharaok/.dotfiles/.config/nvim/lua/pharaok/snippets/cp_template.cpp", "rb")
local template = file:read("*all")
file:close()

local snippets = {
  s("cp", t(vim.split(template, "\n"))),
}

return snippets
