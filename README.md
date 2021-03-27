# nvim-tabline

Simple tabline in lua

<img width="455" alt="image" src="https://user-images.githubusercontent.com/5160701/112729046-7c324600-8f2a-11eb-8c2b-7fb05e3acfaa.png">

## Installation
```Lua
-- using packer.nvim
use {'seblj/nvim-tabline',
  requires = {'kyazdani42/nvim-web-devicons'}
}
```

## Setup

```Lua
require('tabline').setup{
  no_name = '[No Name]',        -- Name for buffers with no name
  modified_icon = '',          -- Icon for showing modified buffer
  separator = '▐',              -- Separator icon on the left side
  space = 3,                    -- Prefix and suffix space
  color_all_icons = false,      -- Color icons in active and inactive tabs
  always_show_tabs = false      -- Always show tabline
}
```
