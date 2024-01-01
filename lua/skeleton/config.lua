local M = {}

M.default_author = function()
	local command = "git config user.name || whoami"
	local handle = io.popen(command)

	if handle == nil then
		return "unknown"
	end

	local result = handle:read("*a")
	handle:close()

	return string.gsub(result, "^%s*(.-)%s*$", "%1")
end

M.default_datetime = function()
	return os.date("%Y-%m-%d %H:%M:%S")
end

M.default_file_name = function()
	return vim.fn.expand("%:r")
end

return M
