local M = {}

M.default_author = function()
  local command = 'git config user.name || whoami'
  local handle = io.popen(command)

  if handle == nil then
    return 'Unknown'
  end

  local result = handle:read("*a")
  handle:close()

  return string.gsub(result, "^%s*(.-)%s*$", "%1")
end

M.default_datetime = function()
  return os.date("%Y-%m-%d %H:%M:%S")
end

M.default_file_name = function()
  return vim.fn.expand('%:r')
end

M.contains = function(table, key)
  return table[key] ~= nil
end

local uv = vim.loop

M.read_file = function(path, callback)
  uv.fs_open(path, "r", 438, function(err, fd)
    assert(not err, err)
    uv.fs_fstat(fd, function(err, stat)
      assert(not err, err)
      uv.fs_read(fd, stat.size, 0, function(err, data)
        assert(not err, err)
        uv.fs_close(fd, function(err)
          assert(not err, err)
          callback(data)
        end)
      end)
    end)
  end)
end

M.is_function = function(var)
  return type(var) == "function"
end

M.is_string = function(var)
  return type(var) == "string"
end

M.dump = function(o)
  if type(o) == 'table' then
    local s = '{ '
    for k, v in pairs(o) do
      if type(k) ~= 'number' then k = '"' .. k .. '"' end
      s = s .. '[' .. k .. '] = ' .. dump(v) .. ','
    end
    return s .. '} '
  else
    return tostring(o)
  end
end

return M
