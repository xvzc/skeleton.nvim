local util = require("skeleton.util")

local core = {}

core.get_template_files = function(opts)
	local template_dir = vim.fs.normalize(opts.config.template_path)

	local only_files = vim.fs.find(function(name)
		return name:match(".*")
	end, { type = "file", path = template_dir, limit = math.huge })

	local only_links = vim.fs.find(function(name)
		return name:match(".*")
	end, { type = "link", path = template_dir, limit = math.huge })

	local all = {}

	local buf_ft = vim.bo.filetype

	for _, path in ipairs(vim.list_extend(only_files, only_links)) do
		local ft = vim.filetype.match({ filename = path })
		local file = {
			path = path,
			filetype = ft,
		}

		if buf_ft == file.filetype or opts.filter(file, opts.config.patterns[buf_ft] or {}) then
			table.insert(all, file)
		end
	end

	return all
end

local function create_tag_values(tags)
	local tag_values = {}

	for k, v in pairs(tags) do
		if util.is_function(v) then
			tag_values[k] = v()
		elseif util.is_string(v) then
			tag_values[k] = v
		end
	end

	return tag_values
end

core.load_template = function(path, opts)
	local tag_values = create_tag_values(opts.tags)
	local lines = {}
	util.read_file(
		path,
		vim.schedule_wrap(function(data)
			local cursor_tag_found = false
			local cursor_tag_line = 0
			local cursor_tag_col = 0

			local cur_cursor_line = vim.api.nvim_win_get_cursor(0)[1]

			for idx, line in pairs(vim.split(data, "\n")) do
				for k, v in pairs(tag_values) do
					line = line:gsub("{{%s*" .. k .. "%s*}}", v)
				end

				if not cursor_tag_found then
					local str, count = string.gsub(line, "{{%s*cursor%s*}}", "")
					if count > 0 then
						line = str
						cursor_tag_found = true
						cursor_tag_line = idx
						cursor_tag_col = string.len(line)
					end
				end

				table.insert(lines, line)
			end

			local cur_buf = vim.api.nvim_get_current_buf()
			local cur_line = vim.api.nvim_win_get_cursor(0)[1]
			local start = cur_line

			if start == 1 and #vim.api.nvim_get_current_line() == 0 then
				start = start - 1
				cur_cursor_line = cur_cursor_line - 1
			end

			vim.api.nvim_buf_set_lines(cur_buf, start, cur_line, true, lines)
			if cursor_tag_found then
				vim.api.nvim_win_set_cursor(0, {
					cur_cursor_line + cursor_tag_line,
					cursor_tag_col,
				})
			end
		end)
	)
end

return core
