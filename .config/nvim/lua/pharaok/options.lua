local opt = vim.opt

opt.timeoutlen = 500

opt.number = true
opt.relativenumber = true
opt.colorcolumn = { 80, 120 }
opt.scrolloff = 10

opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true

opt.updatetime = 100
opt.swapfile = false

opt.splitbelow = true
opt.splitright = true

opt.termguicolors = true

-- vim.api.nvim_create_autocmd("TermOpen", {
--   callback = function()
--     vim.cmd.startinsert()
--   end,
-- })

vim.diagnostic.config({ virtual_text = false })
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    for _, win in ipairs(vim.fn.getwininfo()) do
      if vim.fn.win_gettype(win.winnr) == "popup" then
        return
      end
    end
    vim.diagnostic.open_float(nil, {
      header = false,
      focus = false,
      scope = "cursor",
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost", "CmdlineEnter" },
    })
  end,
})
