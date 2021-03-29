local M = {}
local ok, web = pcall(require, 'nvim-web-devicons')
local hl = require('tabline.highlights')
local opt = require('tabline.config').options
local colors = opt.colors

-- Find correct color
function M.get_attr(group, attr)
  local rgb_val = (vim.api.nvim_get_hl_by_name(group, true) or {})[attr]
  return rgb_val and string.format('#%06x', rgb_val) or 'NONE'
end

-- Return icon with fg color
function M.get_devicon(index, name, extension, color_all)
    local icon, icon_hl = web.get_icon(name, extension, { default = true })
    local active = 'Active'
    local inactive = 'Inactive'
    icon = icon .. ' '
    if ok then
        local color = M.get_attr(icon_hl, 'foreground')
        hl.set_one(icon_hl .. active, {guifg = color, guibg = colors.active_background})
        if not color_all then
            hl.set_one(icon_hl .. inactive, {guifg = colors.inactive_devicon, guibg = colors.inactive_background})
        else
            hl.set_one(icon_hl .. inactive, {guifg = color, guibg = colors.inactive_background})
        end
        return hl.get_hl_item(index, icon_hl, icon)
    else
        return ''
    end
end

function M.get_modified_icon(index, modified, icon)
    if modified == 1 then
        return hl.get_hl_item(index, hl.modified_icon, icon .. ' ')
    else
        return ''
    end
end

function M.get_close_icon(index, modified, close_icon)
    local icon = hl.get_hl_item(index, hl.close_icon, close_icon .. ' ')
    if modified == 1 then
        return ''
    else
        return '%' .. index .. 'X' .. icon .. '%X'
    end
end

return M
