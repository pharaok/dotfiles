local function parse(template)
  local lines = vim.split(template, "\n")
  local cur = nil
  local s_nodes = {}
  for _, line in ipairs(lines) do
    local insert_node_regex = "^(%s*)//%s*@(%d+)"
    local begin_node_regex = "^%s*//%s*@begin%s+(%w+)"
    local end_node_regex = "^%s*//%s*@end%s+(%w+)"
    local b_name = line:match(begin_node_regex)
    local e_name = line:match(end_node_regex)

    if b_name ~= nil then
      cur = b_name
      s_nodes[cur] = {}
    elseif e_name ~= nil then
      cur = nil
    elseif s_nodes[cur] ~= nil then
      local indent, idx = line:match(insert_node_regex)
      if idx ~= nil then
        table.insert(s_nodes[cur], t({ indent }))
        table.insert(s_nodes[cur], i(tonumber(idx), ""))
      else
        table.insert(s_nodes[cur], t({ line }))
      end
      table.insert(s_nodes[cur], t({ "", "" }))
    end
  end
  return s_nodes
end

local dir = vim.fn.stdpath("config") .. "/lua/pharaok/snippets/cpp/cp/"
local cpp_files = vim.fs.find(function(name)
  return name:match("%.cpp$")
end, { path = dir, limit = math.huge })

local snippets = {}
for _, path in ipairs(cpp_files) do
  local file = io.open(path, "rb")
  local content = file:read("*all")
  file:close()

  for name, nodes in pairs(parse(content)) do
    table.insert(snippets, s(name, nodes))
  end
end

return snippets
