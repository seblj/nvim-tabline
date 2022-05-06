local M = {}
local hl = require('tabline.highlights')
local config = require('tabline.config')
local utils = require('tabline.utils')

M.get_devicon = function(index, bufname, extension)
    local enabled = config.get('show_icon')
    local ok, web = pcall(require, 'nvim-web-devicons')
    local filename = vim.fn.fnamemodify(bufname, ':t')

    if enabled and ok then
        local icon, icon_hl = web.get_icon(filename, extension, { default = true })

        icon = icon .. ' '
        local color = hl.get_color(icon_hl, 'fg')
        icon_hl = 'TabLine' .. icon_hl

        local active_color = hl.get_color('TabLineIconSel', 'fg') or color
        hl.highlight(icon_hl .. 'Sel', { guifg = active_color, guibg = hl.c.active_bg })

        local inactive_color = (not config.get('color_all_icons') and hl.c.inactive_text)
            or hl.get_color('TabLineIcon', 'fg')
            or color
        hl.highlight(icon_hl, { guifg = inactive_color, guibg = hl.c.inactive_bg })

        return utils.get_item(icon_hl, icon, index)
    end
    return ''
end

return M
