local core = require('skeleton.core')

local M = {}

M.config = {}

M.test = function()
  print('test okay')
  print(core.get_datetime())
end

M.setup = function(config)
  if not core.contains(config.tags, "timestamp") then
    config.tags.timestamp = core.default_datetime
  end

  if not core.contains(config.tags, "author") then
    config.tags.timestamp = core.default_author
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
