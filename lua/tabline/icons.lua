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
function M.get_devicon(index, name, extension, color_all)
    local icon, icon_hl = web.get_icon(name, extension, { default = true })
    local active = 'Active'
    local inactive = 'Inactive'

    icon = icon .. ' '
    if ok then
        local color = M.get_attr(icon_hl, 'foreground')
        hl.set_one(icon_hl .. active, {guifg = color, guibg = opt.active_background})
        if not color_all then
            hl.set_one(icon_hl .. inactive, {guifg = opt.inactive_text, guibg = opt.inactive_background})
        else
            hl.set_one(icon_hl .. inactive, {guifg = color, guibg = opt.inactive_background})
        end
        if index == vim.fn.tabpagenr() then
            icon_hl = hl.create_hl_group(icon_hl .. 'Active')
        else
            icon_hl = hl.create_hl_group(icon_hl .. 'Inactive')
        end
        return hl.get_item(icon_hl, icon)
    else
        return ''
    end
end

function M.get_modified_icon(index, modified, icon)
    if modified == 1 then
        if index == vim.fn.tabpagenr() then
            return hl.get_item(opt.options.highlights.modified_active.hl, icon .. ' ')
        else
            return hl.get_item(opt.options.highlights.modified_inactive.hl, icon .. ' ')
        end
    else
        return ''
    end
end

function M.get_close_icon(index, modified, close_icon)
    local icon
    if index == vim.fn.tabpagenr() then
        icon = hl.get_item(opt.options.highlights.close_active.hl, close_icon .. ' ')
    else
        icon = hl.get_item(opt.options.highlights.close_inactive.hl, close_icon .. ' ')
    end
    if modified == 1 then
        return ''
    else
        return '%' .. index .. 'X' .. icon .. '%X'
    end
end

return M
