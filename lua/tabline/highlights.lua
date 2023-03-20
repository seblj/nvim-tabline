local M = {}

M.get_color = function(group, attr)
    local color = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID(group)), attr)
    return color ~= '' and color or nil
end

M.c = {
    active_text = '#eeeeee',
    inactive_text = '#7f8490',
    active_sep = '#ff6077',
}

M.get_bg = function(active)
    local group = active and 'TabLineSel' or 'TabLine'
    return M.get_color(group, 'bg')
end

local hi = function(colors)
    for name, opts in pairs(colors) do
        opts.default = true
        vim.api.nvim_set_hl(0, name, opts)
    end
end

-- stylua: ignore start
hi({
    TabLineSeparatorSel = { fg = M.c.active_sep,    bg = M.get_bg(true) } ,
    TabLineSeparator    = { fg = M.c.inactive_text, bg = M.get_bg(false) } ,
    TabLineModifiedSel  = { fg = M.c.active_text,   bg = M.get_bg(true) } ,
    TabLineModified     = { fg = M.c.inactive_text, bg = M.get_bg(false) } ,
    TabLineCloseSel     = { fg = M.c.active_text,   bg = M.get_bg(true) } ,
    TabLineClose        = { fg = M.c.inactive_text, bg = M.get_bg(false) } ,
    TabLinePaddingSel   = { link = 'TabLineSel' },
    TabLinePadding      = { link = 'TabLine' },
})
-- stylua: ignore end

return M
