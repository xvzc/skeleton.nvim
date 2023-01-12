local core = require('skeleton.core')
local util = require('skeleton.util')

local M = {}

M.config = {}

M.test = function()
end

M.setup = function(config)
  if config.tags == nil then
    config.tags = {}
  end

  config.tags.cursor = nil

  if not util.contains(config.tags, "timestamp") then
    config.tags.timestamp = util.default_datetime
  end

  if not util.contains(config.tags, "author") then
    config.tags.author = util.default_author
  end

  for k, v in pairs(config.tags) do
    if not util.is_function(v) and not util.is_string(v) then
      error('The value of \"tags.' .. k .. '\" is not a function or string.')
    end
  end

  M.config = config
end

M.load = function(abs_path, config)
  if config == nil then
    config = M.config
  end

  core.load_template(abs_path, config)
end

return M
