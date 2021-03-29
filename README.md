# nvim-tabline

Simple tabline in lua

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/5160701/112813955-11465380-907f-11eb-93ae-b828ccb23a76.gif)

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
  no_name = '[No Name]',                    -- Name for buffers with no name
  modified_icon = '',                      -- Icon for showing modified buffer
  close_icon = '',                         -- Icon for closing tab with mouse
  separator = "▌",                          -- Separator icon on the left side
  space = 3,                                -- Prefix and suffix space
  color_all_icons = false,                  -- Color devicons in active and inactive tabs
  always_show_tabs = false,                 -- Always show tabline
  right_separator = false,                  -- Show right separator on the last tab
  colors = {
      active_background = '#1c1c1c',        -- Color of background in active tab
      inactive_background = '#121212',      -- Color of background in inactive tab
      active_filename = '#eeeeee',          -- Color of filename in active tab
      inactive_filename = '#7f8490',        -- Color of filename in inactive tab
      active_sep = '#ff6077',               -- Color of left separator in active tab
      inactive_sep = '#7f8490',             -- Color of separator in inactive tab
      active_mod_icon = '#eeeeee',          -- Color of modified_icon in active tab
      inactive_mod_icon = '#7f8490',        -- Color of modified_icon in inactive tab
      active_close_icon = '#7f8490',        -- Color of close_icon in active tab
      inactive_close_icon = '#7f8490',      -- Color of close_icon in inactive tab
      inactive_devicon = '#7f8490'          -- Color of devicon in inactive tab
    }

}
```
