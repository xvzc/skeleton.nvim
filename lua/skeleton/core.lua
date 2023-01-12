local util = require('skeleton.util')

local M = {}

local function create_tag_values(table)
  local tag_values = {}

  for k, v in pairs(table) do
    if util.is_function(v) then
      tag_values[k] = v()
    elseif util.is_string(v) then
        tag_values[k] = v
    end
  end

  return tag_values
end

M.load_template = function(abs_path, config)
  local tag_values = create_tag_values(config.tags)
  local lines = {}
  util.read_file(abs_path,
    vim.schedule_wrap(function(data)
      local cursor_found = false
      local cur_cursor_line = vim.api.nvim_win_get_cursor(0)[1]
      local cursor_tag_line = 0

      for idx, line in pairs(vim.split(data, '\n')) do
        for k, v in pairs(tag_values) do
          line = line:gsub("{{%s*" .. k .. "%s*}}", v)
        end

        if not cursor_found then
          local str, count = string.gsub(line, ".*{{%s*cursor%s*}}", "")
          if count > 0 then
            cursor_found = true
            line = str
            cursor_tag_line = idx
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
      if cursor_found then
        vim.api.nvim_win_set_cursor(0, {cur_cursor_line + cursor_tag_line, 0})
      end
    end)
  )
end

return M
