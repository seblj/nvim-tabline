local M = {}
local config = require('tabline.config')

M.get_item = function(group, item, index, modified)
    local active = index == vim.fn.tabpagenr()
    if modified then
        group = group .. 'Modified'
    end
    if active then
        group = group .. 'Sel'
    end

    -- Special case for close icon
    if group:match('TabLineClose') then
        if modified or item == '' then
            return ''
        end

        local icon = '%#' .. group .. '#' .. item .. '%*'
        return '%' .. index .. 'X' .. icon .. '%X'
    end

    return '%#' .. group .. '#' .. item .. '%*'
end

M.get_tabname = function(bufname, index)
    local title = vim.fn.gettabvar(index, 'TablineTitle')
    if title ~= vim.NIL and title ~= '' then
        return title
    end
    if bufname == '' then
        return config.get('no_name')
    end
    return vim.fn.fnamemodify(bufname, ':t')
end

return M
