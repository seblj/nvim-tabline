local M = {}
local opt = require('tabline.config').options
local hl = require('tabline.highlights')

function M.find_filename(bufname)
    if bufname == '' then
        return opt.no_name .. ' '
    else
        return vim.fn.fnamemodify(bufname, ':t') .. ' '
    end
end

function M.find_affixes()
    local prefix = string.rep(' ', opt.space)
    local suffix = string.rep(' ', opt.space)
    return prefix, suffix
end

function M.get_right_separator(index, group, item)
    if index == vim.fn.tabpagenr('$') and opt.right_separator then
        return hl.get_item(group, item)
    else
        return ''
    end
end


return M
