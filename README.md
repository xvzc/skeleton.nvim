<div align="center">
  <h1 align="center">skeleton.nvim</h2>
</div>
<br>
<div align="center">
  <p>Load your templates with custom defined variables or functions.</p>
  <img src="https://github.com/xvzc/skeleton.nvim/assets/45588457/208ee87c-5709-4099-bfb6-dba4766fff88" alt="demo">
</div>

# Minimal configuration
```lua
use {

    'xvzc/skeleton.nvim',
    config = function()
        require('skeleton').setup({
            template_path = vim.fn.stdpath('config') .. '/templates',
            patterns = {}
            tags = {
                author = 'my-nickname'
            }
        })
    end
}
```

# Tags
## Built-in tags
There's a couple of built-int tags, you can also override those tags.
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

## Patterns
When using telescope, skeleton.nvim will basically give you the list of files that has same filetype as the current buffer, 
but we can also set list of patterns for each filetypes, so that template files that have different filetypes can be listed.
```lua
{
  patterns = {
        javascript = { "*.cjs" }
  }
}
```

# Integration with telescope 
Add the line below to the bottom of your Telescope config.
```lua
telescope.load_extension('skeleton')
```

# Usage
```
:lua require('skeleton').load('/home/john/example.txt')
```
```
:Telescope skeleton load_template<CR>
```


# Inspirations
- [template.nvim](https://github.com/glepnir/template.nvim)
