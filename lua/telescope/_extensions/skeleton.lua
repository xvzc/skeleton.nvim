local telescope = require('telescope')
local finders = require('telescope.finders')
local pickers = require('telescope.pickers')
local make_entry = require('telescope.make_entry')
local config = require('telescope.config').values
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local skeleton = require('skeleton')

local get_template_files = function(opts)
  local filetype_filenames_tbl = require('skeleton.core')
      .get_template_files(skeleton.config)

  local flatten_filenames = {}
  for _, v in pairs(filetype_filenames_tbl) do
    flatten_filenames = vim.list_extend(flatten_filenames, v)
  end

  return flatten_filenames
end

local load_template = function(opts)
  opts = opts or {}
  local template_filenames = get_template_files()

  local tbl = {
    prompt_title = 'templates',
    finder = finders.new_table({
      results = template_filenames,
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
