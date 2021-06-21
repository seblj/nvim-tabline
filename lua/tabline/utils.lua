local M = {}
local opt = require('tabline.config').options

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

M.find_filename = function(bufname)
    if bufname == '' then
        return opt.no_name .. ' '
    end
    return vim.fn.fnamemodify(bufname, ':t') .. ' '
end

return M
