local M = {}

M.get_color = function(group, attr)
    local color = vim.fn.synIDattr(vim.fn.hlID(group), attr)
    return color ~= '' and color or nil
end

M.c = {
    active_bg = M.get_color('TabLineSel', 'bg'),
    inactive_bg = M.get_color('TabLine', 'bg'),
    active_text = '#eeeeee',
    inactive_text = '#7f8490',
    active_sep = '#ff6077',
}

local hi = function(colors)
    for name, opts in pairs(colors) do
        vim.api.nvim_set_hl(0, name, opts)
    end
end

-- stylua: ignore start
hi({
     TabLineSeparatorSel = { fg = M.c.active_sep,    bg = M.c.active_bg } ,
     TabLineSeparator    = { fg = M.c.inactive_text, bg = M.c.inactive_bg } ,
     TabLineModifiedSel  = { fg = M.c.active_text,   bg = M.c.active_bg } ,
     TabLineModified     = { fg = M.c.inactive_text, bg = M.c.inactive_bg } ,
     TabLineCloseSel     = { fg = M.c.active_text,   bg = M.c.active_bg } ,
     TabLineClose        = { fg = M.c.inactive_text, bg = M.c.inactive_bg } ,
     TabLinePaddingSel   = { link = 'TabLineSel' },
     TabLinePadding      = { link = 'TabLine' },
})
-- stylua: ignore end

return M
