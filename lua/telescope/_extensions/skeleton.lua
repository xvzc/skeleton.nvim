local telescope = require("telescope")
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")
local make_entry = require("telescope.make_entry")
local config = require("telescope.config").values
local actions = require("telescope.actions")
local action_state = require("telescope.actions.state")
local skeleton = require("skeleton")
local core = require("skeleton.core")

local function flatten(results)
	local ret = {}
	for _, v in ipairs(results) do
		table.insert(ret, v.path)
	end
	return ret
end

local load_template = function(opts)
	opts = opts or {}
	local files = core.get_template_files({
		config = skeleton.config,
		filter = function(file, patterns)
			for _, v in ipairs(patterns) do
				if file.path:match("." .. v) then
					return true
				end
			end

			return false
		end,
	})
	local tbl = {
		prompt_title = "templates",
		finder = finders.new_table({
			results = flatten(files),
			entry_maker = make_entry.gen_from_file(opts),
		}),
		previewer = config.file_previewer(opts),
		sorter = config.file_sorter(opts),
	}

	tbl.attach_mappings = function(prompt_bufnr, _)
		actions.select_default:replace(function()
			actions.close(prompt_bufnr)
			local selection = action_state.get_selected_entry()
			local template_abs_path = selection[1]

			skeleton.load(template_abs_path)
		end)
		return true
	end

	pickers.new(opts, tbl):find()
end

return telescope.register_extension({ exports = { load_template = load_template } })
