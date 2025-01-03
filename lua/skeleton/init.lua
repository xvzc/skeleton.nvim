local core = require("skeleton.core")
local config = require("skeleton.config")

---@class Skeleton
---@field config table
local skeleton = {}

local default_config = {
	template_path = vim.fn.stdpath("config") .. "/skeleton",
	tags = {
		timestamp = config.default_datetime,
		author = config.default_author,
		file_name = config.default_file_name,
	},
	patterns = {},
}

---@private
local function __recursive_apply(key, opts, default)
	if type(opts) == "table" then
		for k, _ in pairs(opts) do
			if default[k] == nil then
				opts[k] = nil
			end
		end
	end

	if type(default[key]) ~= "table" then
		opts[key] = opts[key] or default[key]
		return
	else
		opts[key] = opts[key] or {}
	end

	for k, _ in pairs(default[key]) do
		__recursive_apply(k, opts[key], default[key])
	end
end

skeleton.setup = function(opts)
	skeleton.config =  vim.tbl_deep_extend('force', default_config, opts or {})
	vim.g.skeleton_setup = 1
end

---@param path string
---@param opts table
---@return nil
skeleton.load = function(path, opts)
	if opts == nil then
		opts = skeleton.config
	end

	core.load_template(path, opts)
end

return skeleton
