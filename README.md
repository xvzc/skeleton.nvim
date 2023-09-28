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
            template_path = vim.fn.stdpath('config') .. '/templates',
            tags = {
                author = 'my-nickname'
            }
        })
    end
}
```

# Tags
## Built-in tags
```
{{ author }} // This will be replaced with the output of 'git config user.name' or 'whoami', also you can replcae this tag with any other function or string values
{{ timestamp }} // The default format of timestamp tag will be '%Y-%m-%d %H:%M:%S' format.
```

## Custom tags
You can use the custom tags with `{{ key }}` syntax in your template files, and it will be replaced with the values (or functions) when you call `load()` function.
```lua
{
  tags = {
    key1 = 'value1',
    key2 = function()
      return os.date("%Y-%m-%d") 
    end
  }
}
```

# Usage
```
:lua require('skeleton').load('/home/john/example.txt')
```

# Support telescopt
Add the line below to the bottom of your Telescope config.
```lua
telescope.load_extension('skeleton')
```

# Inspirations
- [template.nvim](https://github.com/glepnir/template.nvim)
