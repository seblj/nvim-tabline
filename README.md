# Tabline for NeoVim

Forked and borked for personal use.

# Setup

The default settings are as of now [settings.lua](lua/tabline/settings.lua)

```lua
require('tabline').setup{
  -- Default name of an empty buffer
  nameless = '[Empty buffer]',

  -- Try to keep icons the same length
  icon_modified = '🦆',
  icon_close = '🐤',

  -- Left and right of every tab
  separator_left = '|»',
  separator_right = '',

  -- Amount of spaces left and right of every filename
  padding = 2,
}
```

## Highlight groups

All colouring can be customized with the following highlight groups.

```vim
TabLine
TabLineSel
TabLineFill
TabLineSeparatorActive
TabLineSeparatorInactive
TabLinePaddingActive
TabLinePaddingInactive
TabLineModifiedActive
TabLineModifiedInactive
TabLineCloseActive
TabLineCloseInactive
```

#
