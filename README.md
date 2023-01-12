# skeleton.nvim
Minimal and fully configurable template loader for neovim users.  
Load your templates with custom defined variables or functions!

![skeleton](https://user-images.githubusercontent.com/45588457/211829055-4ee23d0e-3e34-42d7-8bf8-363192268751.gif)

# Minimal configuration
```lua
  use {
    'xvzc/skeleton.nvim',
    config = function()
      require('skeleton').setup({
        template_path = vim.fn.stdpath('config') .. '/templates', -- required
        tags = {}
      })
    end
  }
```
# Custom tags
You can use the custom tags with `{{ key }}` syntax in your template files, and it will be replaced with the values (or functions) when you call `load()` function.
```lua
{
  template_path = vim.fn.stdpath('config') .. '/templates', -- required
  tags = {
    author = 'john', -- The default value of author will be output of 'git config user.name' or 'whoami'.
    timestamp = function() -- The default value of timestamp tag will be '%Y-%m-%d %H:%M:%S' format.
      return os.date("%Y-%m-%d") 
    end
  }
}
```

# Usage
```
:lua require('skeleton').load('example.txt')
-- we only need the filename because the template_path is pre-defined in the config
```

# Configuration for fzf-lua users
Add below to your `fzf-lua` settings
```lua
local skeleton = require('skeleton')
util.nmap(
  '<C-M-t>',
  function()
    fzf_lua.files({
      file_icons = true,
      git_icons = false,
      cwd = skeleton.get_template_path(),
      preview = "bat --style=plain {}",
      fzf_opts = { ['--preview-window'] = 'nohidden,down,50%' },
      actions = {
        ['default'] = function(selected, opts)
          local entry = fzf_lua.path.entry_to_file(selected[1])
          local abs_path = entry.path
          if not fzf_lua.path.starts_with_separator(abs_path) then
            abs_path = fzf_lua.path.join({ opts.cwd or vim.loop.cwd(), abs_path })
          end
          skeleton.load(abs_path)
        end,
      }
    })
  end,
  buf_opt
)
```

# Inspirations
- [template.nvim](https://github.com/glepnir/template.nvim)
- [fzf-lua](https://github.com/ibhagwan/fzf-lua)
