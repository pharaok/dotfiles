return function(mode, l, r, opts)
  opts = opts or { noremap = true, silent = true }
  vim.keymap.set(mode, l, r, opts)
end
