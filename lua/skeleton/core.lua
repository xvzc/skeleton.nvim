local util = require('skeleton.util')

local M = {}

M.get_template_files = function(opts)
  if opts == nil then
    opts = {}
  end

  local template_dir = vim.fs.normalize(opts.template_path)

  local files = vim.fs.find(function(name)
    return name:match('.*')
  end, { type = 'file', path = template_dir, limit = math.huge })

  local links = vim.fs.find(function(name)
    return name:match('.*')
  end, { type = 'link', path = template_dir, limit = math.huge })

  local all = vim.list_extend(files, links)

  local filetype_filenames_tbl = {}
  for _, name in ipairs(all) do
    local ft = vim.filetype.match({ filename = name })
    if ft then
      if not filetype_filenames_tbl[ft] then
        filetype_filenames_tbl[ft] = {}
      end
      filetype_filenames_tbl[ft][#filetype_filenames_tbl[ft] + 1] = name
    else
      vim.notify(
        '[skeleton.nvim] No such template file ' .. name,
        vim.log.levels.INFO
      )
    end
  end

  return filetype_filenames_tbl
end

local function create_tag_values(tags)
  local tag_values = {}

  for k, v in pairs(tags) do
    if util.is_function(v) then
      tag_values[k] = v()
    elseif util.is_string(v) then
      tag_values[k] = v
    end
  end

  return tag_values
end

M.load_template = function(abs_path, opts)
  local tag_values = create_tag_values(opts.tags)
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
          local str, count = string.gsub(line, ".*{{%s*" .. opts.tags.cursor .. "%s*}}", "")
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
        vim.api.nvim_win_set_cursor(0, { cur_cursor_line + cursor_tag_line, 0 })
      end
    end)
  )
end

return M
