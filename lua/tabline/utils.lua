local M = {}
local config = require('tabline.config')

-- sel is optional
-- Append 'Sel' if true to use default highlight group
M.get_item = function(group, item, active, sel)
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
