local M = {}

function M.root_dir()
  local clients = vim.lsp.get_active_clients()
  if vim.tbl_isempty(clients) then
    return nil
  end
  return vim.lsp.get_active_clients()[1].config.root_dir
end

function M.has(plugin)
  return require("lazy.core.config").plugins[plugin] ~= nil
end

return M
