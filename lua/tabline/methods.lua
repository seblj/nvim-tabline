-- all local variables
----------------------
local settings = require('tabline.settings')
local colours

-- all local functions
----------------------
local function get_color(group, attr)
  return vim.fn.synIDattr(vim.fn.hlID(group), attr)
end

local function default_none(option)
  if option == nil or option == '' then
    return 'NONE'
  end
  return option
end

local function highlight(name, options)
  options.guibg = default_none(options.guibg)
  options.guifg = default_none(options.guifg)
  options.guisp = default_none(options.guisp)
  options.gui = default_none(options.gui)

  if name and vim.tbl_count(options) > 0 then
    if options.link and options.link ~= '' then
      vim.cmd('highlight!' .. ' link ' .. name .. ' ' .. options.link)
    else
      local command = { 'highlight!', name }

      for k, v in pairs(options) do
        table.insert(command, string.format('%s=', k) .. v)
      end

      vim.cmd(table.concat(command, ' '))
    end
  end
end

local function highlight_all(hls)
  for _, hl in ipairs(hls) do
    highlight(unpack(hl))
  end
end

colours = {
  inactive_bg = get_color('TabLine', 'bg'),
  active_bg = get_color('TabLineSel', 'bg'),
  inactive_text = get_color('Pmenu', 'fg'),
  active_text = get_color('PmenuSel', 'fg'),
  active_sep = get_color('ColorColumn', 'fg'),
}

-- Run the highlighting function
highlight_all({
  {
    'TabLineSeparatorActive',
    {
      guifg = colours.active_sep,
      guibg = colours.active_bg,
    }
  },
  {
    'TabLineSeparatorInactive',
    {
      guifg = colours.inactive_text,
      guibg = colours.inactive_bg,
    }
  },
  {
    'TabLinePaddingActive',
    {
      guifg = colours.active_bg,
      guibg = colours.active_bg,
    }
  },
  {
    'TabLinePaddingInactive',
    {
      guifg = colours.inactive_bg,
      guibg = colours.inactive_bg,
    }
  },
  {
    'TabLineModifiedActive',
    {
      guifg = colours.active_text,
      guibg = colours.active_bg,
    }
  },
  {
    'TabLineModifiedInactive',
    {
      guifg = colours.inactive_text,
      guibg = colours.inactive_bg,
    }
  },
  {
    'TabLineCloseActive',
    {
      guifg = colours.active_text,
      guibg = colours.active_bg,
    }
  },
  {
    'TabLineCloseInactive',
    {
      guifg = colours.inactive_text,
      guibg = colours.inactive_bg,
    }
  },
})

local function get_item(group, item, active, sel)
  if active then
    if sel then
      group = group .. 'Sel'
    else
      group = group .. 'Active'
    end
  else
    if not sel then
      group = group .. 'Inactive'
    end
  end

  return '%#' .. group .. '#' .. item .. '%*'
end

local function get_icon_modified(hl_group, active, modified)
  if modified == 1 then
    return get_item(hl_group, settings.icon_modified .. ' ', active, nil)
  end
  return ''
end

local function get_icon_close(hl_group, index, modified)
  if modified == 1 then
    return ''
  end

  local active = index == vim.fn.tabpagenr()
  local icon = get_item(hl_group, settings.icon_close .. ' ', active, nil)
  return '%' .. index .. 'X' .. icon .. '%X'
end

local function get_right_separator(hl_group, right_separator)
  if right_separator then
    return get_item(hl_group, settings.separator_right, nil, nil)
  end
  return ''
end

local function find_filename(bufname)
  if bufname == nil or bufname == '' then
    return settings.nameless .. ' '
  end

  return vim.fn.fnamemodify(bufname, ':t') .. ' '
end

function create_tabline(options)
  local s = ''
  for index = 1, vim.fn.tabpagenr('$') do
    local winnr = vim.fn.tabpagewinnr(index)
    local bufnr = vim.fn.tabpagebuflist(index)[winnr]
    -- local bufname = vim.fn.bufname(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local bufmodified = vim.fn.getbufvar(bufnr, "&mod")
    local filename = find_filename(bufname)
    local extension = vim.fn.fnamemodify(bufname, ':e')
    local padding = string.rep(' ', settings.padding)

    -- Make clickable
    s = s .. '%' .. index .. 'T'

    local active = index == vim.fn.tabpagenr()

    local tab_items = {
      get_item('TabLineSeparator', options.separator_left, active, nil),
      get_item('TabLinePadding', padding, active, nil),
      get_item('TabLine', filename, active, true),
      get_item('TabLinePadding', padding, active, nil),
      get_icon_modified('TabLineModified', active, bufmodified),
      get_icon_close('TabLineClose', index, bufmodified),
      get_right_separator('TabLineSeparator', settings.separator_right),
    }
    s = s .. table.concat(tab_items)
  end

  return s
end

-- exported functions
---------------------
local methods = {}

function methods.Setup(update)
  settings = setmetatable(update, { __index = settings })

  -- Make the tabline globally accessible
  function _G.nvim_tabline()
    return create_tabline(settings)
  end

  vim.o.tabline = "%!v:lua.nvim_tabline()"
  vim.g.loaded_nvim_tabline = 1
end

return methods
