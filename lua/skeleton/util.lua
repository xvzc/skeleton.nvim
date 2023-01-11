local M = {}

M.default_author = function()
  os.execute('git config user.name | whoami')
end

M.default_datetime = function()
    return os.date("%Y-%m-%d %H:%M:%S")
end

M.contains = function(table, key)
  return table[key] ~= nil
end

return M
