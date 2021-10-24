# nvim-tabline

Simple tabline in lua

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/5160701/112813955-11465380-907f-11eb-93ae-b828ccb23a76.gif)

## Requirements
- Neovim 0.5+ (_nightly_)
- A patched font (see [nerd fonts](https://github.com/ryanoasis/nerd-fonts))
- Termguicolors should be set

## Installation

### packer.nvim
```Lua
use {'seblj/nvim-tabline',
    requires = {'kyazdani42/nvim-web-devicons'}
}
```

### vim-plug
```Vim
call plug#begin()

Plug 'seblj/nvim-tabline'
Plug 'kyazdani42/nvim-web-devicons'             " Optional

call plug#end()
```

## Setup

```Lua
require('tabline').setup{
    no_name = '[No Name]',    -- Name for buffers with no name
    modified_icon = '',      -- Icon for showing modified buffer
    close_icon = '',         -- Icon for closing tab with mouse
    separator = "▌",          -- Separator icon on the left side
    padding = 3,              -- Prefix and suffix space
    color_all_icons = false,  -- Color devicons in active and inactive tabs
    always_show_tabs = false, -- Always show tabline
    right_separator = false,  -- Show right separator on the last tab
    show_index = false,       -- Shows the index of tab before filename
    show_icon = true,         -- Shows the devicon
}
```

## Highlight groups

```
TabLine
TabLineSel
TabLineFill
TabLineSeparatorActive
TabLineSeparatorInactive
TabLineModifiedSeparatorActive
TabLineModifiedSeparatorInactive
TabLinePaddingActive
TabLinePaddingInactive
TabLineModifiedActive
TabLineModifiedInactive
TabLineCloseActive
TabLineCloseInactive
```
