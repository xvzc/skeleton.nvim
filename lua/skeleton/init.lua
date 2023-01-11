local core = require('skeleton.core')
local util = require('skeleton.util')

local M = {}

M.config = {
  tags = {}
}

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

  if not util.contains(config, "template_path") then
    print('\"template_path\" is not set. Add it to your config.')
  end

  M.config = config
end

M.load = function(file_path, config)
  if config == nil then
    config = M.config
  end

  core.load_template(file_path, config)
end

return M
