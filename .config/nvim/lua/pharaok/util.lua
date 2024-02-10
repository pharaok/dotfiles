local M = {}

function M.get_visual()
  vim.cmd("normal!u")
  -- local region =
  --   vim.region(0, vim.api.nvim_buf_get_mark(0, "<"), vim.api.nvim_buf_get_mark(0, ">"), vim.fn.visualmode(), true)
  -- local text = ""
  -- local maxcol = vim.v.maxcol
  -- for line, cols in vim.spairs(region) do
  --   local endcol = cols[2] == maxcol and -1 or cols[2]
  --   local chunk = vim.api.nvim_buf_get_text(0, line, cols[1], line, endcol, {})[1]
  --   text = ("%s%s\n"):format(text, chunk)
  -- end
  -- return text

  local vstart = vim.api.nvim_buf_get_mark(0, "<")
  local vend = vim.api.nvim_buf_get_mark(0, ">")

  local lines = vim.api.nvim_buf_get_lines(0, vstart[1] - 1, vend[1], true)

  lines[#lines] = lines[#lines]:sub(1, vend[2] + 1)
  lines[1] = lines[1]:sub(vstart[2] + 1)

  return table.concat(lines, "\n")
end

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

function M.str_split(str, delim)
  if delim == nil then
    delim = "\n"
  end
  local segments = {}
  local i = 1
  for segment in str:gmatch("([^" .. delim .. "]+)") do
    segments[i] = segment
    i = i + 1
  end
  return segments
end

return M
