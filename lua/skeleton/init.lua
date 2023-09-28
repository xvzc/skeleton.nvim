local core = require('skeleton.core')
local util = require('skeleton.util')

local M = {}

M.config = {}

M.setup = function(opts)
  if opts.template_path == nil then
    opts.template_path = vim.fn.stdpath('config') .. '/templates'
  end

  if opts.tags == nil then
    opts.tags = {}
  end

  if not util.contains(opts.tags, "timestamp") then
    opts.tags.timestamp = util.default_datetime
  end

  if not util.contains(opts.tags, "author") then
    opts.tags.author = util.default_author
  end

  if not util.contains(opts.tags, "file_name") then
    opts.tags.file_name = util.default_file_name
  end

  for k, v in pairs(opts.tags) do
    if not util.is_function(v) and not util.is_string(v) then
      error('The value of \"tags.' .. k .. '\" is not a function or string.')
    end
  end

  M.config = opts
end

M.load = function(abs_path, opts)
  if opts == nil then
    opts = M.config
  end

  core.load_template(abs_path, opts)
end

return M
