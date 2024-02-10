require("pharaok.options")
require("pharaok.keymap")

-- bootstrap python3 venv
local pyvenv_path = vim.fn.stdpath("data") .. "/pharaok/venv"
if not vim.loop.fs_stat(pyvenv_path) then
  vim.fn.system({ "python3", "-m", "venv", pyvenv_path })
end
vim.g.python3_host_prog = pyvenv_path .. "/bin/python3"
vim.fn.system({
  pyvenv_path .. "/bin/pip",
  "install",
  "-r",
  vim.fn.stdpath("config") .. "/requirements.txt",
})
vim.cmd.python3(("sys.path.insert(1, r'%s'); import util"):format(vim.fn.stdpath("config")))

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup("pharaok.plugins", {
  checker = {
    enabled = true,
    notify = false,
  },
  change_detection = {
    notify = false,
  },
})
