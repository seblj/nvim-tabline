local M = {}
local ok, web = pcall(require, 'nvim-web-devicons')
local hl = require('tabline.highlights')
local opt = require('tabline.config')

-- Find correct color
function M.get_attr(group, attr)
  local rgb_val = (vim.api.nvim_get_hl_by_name(group, true) or {})[attr]
  return rgb_val and string.format('#%06x', rgb_val) or 'NONE'
end

-- Return icon with fg color
function M.get_devicon(index, filename, extension)
    if ok then
        local icon, icon_hl = web.get_icon(filename, extension, { default = true })
        local active = 'Active'
        local inactive = 'Inactive'

        icon = icon .. ' '
        local color = M.get_attr(icon_hl, 'foreground')
        hl.highlight(icon_hl .. active, {guifg = color, guibg = opt.active_background})
        if not opt.color_all_icons then
            hl.highlight(icon_hl .. inactive, {guifg = hl.c.inactive_text, guibg = hl.c.inactive_bg})
        else
            hl.highlight(icon_hl .. inactive, {guifg = color, guibg = opt.inactive_bg})
        end
        if index == vim.fn.tabpagenr() then
            icon_hl = hl.create_hl_group(icon_hl .. active)
        else
            icon_hl = hl.create_hl_group(icon_hl .. inactive)
        end
        return hl.get_item(icon_hl, icon)
    else
        return ''
    end
end

function M.get_modified_icon(index, modified, icon)
    if modified == 1 then
        if index == vim.fn.tabpagenr() then
            return hl.get_item('TablineModifiedActive', icon .. ' ')
        else
            return hl.get_item('TablineModifiedInactive', icon .. ' ')
        end
    else
        return ''
    end
end

function M.get_close_icon(index, modified, close_icon)
    local icon
    if index == vim.fn.tabpagenr() then
        icon = hl.get_item('TablineCloseActive', close_icon .. ' ')
    else
        icon = hl.get_item('TablineCloseInactive', close_icon .. ' ')
    end
    if modified == 1 then
        return ''
    else
        return '%' .. index .. 'X' .. icon .. '%X'
    end
end

return M
