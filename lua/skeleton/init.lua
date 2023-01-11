local core = require('skeleton.core')

local M = {}

M.test = function()
  print('test okay')
  print(core.datetime())
end

M.setup = function(config)
  M.tags = config.tags
end

return M
