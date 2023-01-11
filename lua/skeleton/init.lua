local core = require('skeleton.core')
local util = require('skeleton.core')

local M = {}

M.config = {}

M.test = function()
  print('test okay')
  print(util.get_datetime())
end

M.setup = function(config)
  if not util.contains(config.tags, "timestamp") then
    config.tags.timestamp = util.default_datetime
  end

  if not util.contains(config.tags, "author") then
    config.tags.timestamp = util.default_author
  end

  M.config = config
end

M.load = function(file_path, config)
  if config ~= nil then
    core.load_template(file_path, config)
  else
    core.load_template(file_path, M.config)
  end
end

return M
