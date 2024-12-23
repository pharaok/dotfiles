local M = {}

function M.get_visual()
  vim.cmd("normal!u")

  local vstart = vim.api.nvim_buf_get_mark(0, "<")
  local vend = vim.api.nvim_buf_get_mark(0, ">")

  local lines = vim.api.nvim_buf_get_lines(0, vstart[1] - 1, vend[1], true)

  lines[#lines] = lines[#lines]:sub(1, vend[2] + 1)
  lines[1] = lines[1]:sub(vstart[2] + 1)

  return table.concat(lines, "\n")
end

function M.root_dir()
  local clients = vim.lsp.get_active_clients() -- WARN: Deprecated
  if vim.tbl_isempty(clients) then
    return nil
  end
  return vim.lsp.get_active_clients()[1].config.root_dir -- WARN: Deprecated
end

function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

return M
