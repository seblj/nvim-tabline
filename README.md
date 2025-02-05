# nvim-tabline

Simple tabline in lua

![ezgif com-video-to-gif](https://user-images.githubusercontent.com/5160701/112813955-11465380-907f-11eb-93ae-b828ccb23a76.gif)

## Notes

This is a very minimal tabline, and I kind of see it as feature complete. I will still fix potential bugs
and also approve PR's. However, I usually don't want to include complex features that requires a lot of code.

[Yinameah/nvim-tabline](https://github.com/Yinameah/nvim-tabline) is a fork that has proposed a couple of very cool
features, but I have respectfully rejected them because I don't want the added maintenance burden :)

Check that fork out for some cool features like

- Unique names
- Truncation of long names

## Requirements

- Neovim 0.7+
- A patched font (see [nerd fonts](https://github.com/ryanoasis/nerd-fonts))
- Termguicolors should be set

## Installation

### packer.nvim

```lua
use({ 'seblyng/nvim-tabline', requires = { 'nvim-tree/nvim-web-devicons' } })
```

### vim-plug

```vim
call plug#begin()

Plug 'seblyng/nvim-tabline'
Plug 'nvim-tree/nvim-web-devicons'             " Optional

call plug#end()
```

### lazy.nvim

```lua
return {
    'seblyng/nvim-tabline',
    dependencies = { 'nvim-tree/nvim-web-devicons' }, -- Optional
    opts = {
        ..., -- see options below
    },
}
```

## Setup

```lua
require('tabline').setup({
    no_name = '[No Name]', -- Name for buffers with no name
    modified_icon = '', -- Icon for showing modified buffer
    close_icon = '', -- Icon for closing tab with mouse
    separator = '▌', -- Separator icon on the left side
    padding = 3, -- Prefix and suffix space
    color_all_icons = false, -- Color devicons in active and inactive tabs
    right_separator = false, -- Show right separator on the last tab
    show_index = false, -- Shows the index of tab before filename
    show_icon = true, -- Shows the devicon
    show_window_count = {
        enable = false, -- Shows the number of windows in tab after filename
        show_if_alone = false, -- do not show count if unique win in a tab
        count_unique_buf = true, -- count only win showing different buffers
        count_others = true, -- display [+x] where x is the number of other windows
        buftype_blacklist = { 'nofile' }, -- do not count if buftype among theses
    },
})
```

## Configurations

#### Change tabname

Will prompt you for a custom tabname

```lua
require('tabline.actions').set_tabname()
```

#### Clear custom tabname

Clears the custom tabname and goes back to default

```lua
require('tabline.actions').clear_tabname()
```

## Highlight groups

```
TabLine
TabLineSel
TabLineFill
TabLineSeparatorSel
TabLineSeparator
TabLineModifiedSel
TabLineModified
TabLineCloseSel
TabLineClose
TabLineIconSel (Only works with fg color)
TabLineIcon (Only works with fg color)
```
