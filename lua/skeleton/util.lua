local util = {}

util.contains = function(table, key)
	return table[key] ~= nil
end

local uv = vim.loop

util.read_file = function(path, callback)
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

util.is_function = function(var)
	return type(var) == "function"
end

util.is_string = function(var)
	return type(var) == "string"
end

---@private
util.__dump = function(o)
	if type(o) == "table" then
		local s = "{ "
		for k, v in pairs(o) do
			if type(k) ~= "number" then
				k = '"' .. k .. '"'
			end
			s = s .. "[" .. k .. "] = " .. dump(v) .. ","
		end
		return s .. "} "
	else
		return tostring(o)
	end
end

return util
