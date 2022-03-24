local M = {}

M.get_color = function(group, attr)
    return vim.fn.synIDattr(vim.fn.hlID(group), attr)
end

M.highlight = function(name, opts)
    if opts.guibg == '' then
        opts.guibg = 'NONE'
    end
    if opts.guifg == '' then
        opts.guifg = 'NONE'
    end
    if not opts.guisp then
        opts.guisp = 'NONE'
    end
    if not opts.gui then
        opts.gui = 'NONE'
    end
    if name and vim.tbl_count(opts) > 0 then
        if opts.link and opts.link ~= '' then
            vim.cmd('highlight default' .. ' link ' .. name .. ' ' .. opts.link)
        else
            local command = { 'highlight default', name }
            for k, v in pairs(opts) do
                table.insert(command, string.format('%s=', k) .. v)
            end
            vim.cmd(table.concat(command, ' '))
        end
    end
end

M.highlight_all = function(hls)
    for name, hl in pairs(hls) do
        M.highlight(name, hl)
    end
end

M.c = {
    active_bg = M.get_color('TabLineSel', 'bg'),
    inactive_bg = M.get_color('TabLine', 'bg'),
    active_text = '#eeeeee',
    inactive_text = '#7f8490',
    active_sep = '#ff6077',
    modified_active_sep = '#ff6077',
}

-- stylua: ignore
M.highlight_all({
     TabLineSeparatorActive           = { guifg = M.c.active_sep,           guibg = M.c.active_bg } ,
     TabLineSeparatorInactive         = { guifg = M.c.inactive_text,        guibg = M.c.inactive_bg } ,
     TabLineModifiedSeparatorActive   = { guifg = M.c.modified_active_sep,  guibg = M.c.active_bg } ,
     TabLineModifiedSeparatorInactive = { guifg = M.c.inactive_text,        guibg = M.c.inactive_bg } ,
     TabLinePaddingActive             = { guifg = M.c.active_bg,            guibg = M.c.active_bg } ,
     TabLinePaddingInactive           = { guifg = M.c.inactive_bg,          guibg = M.c.inactive_bg } ,
     TabLineModifiedActive            = { guifg = M.c.active_text,          guibg = M.c.active_bg } ,
     TabLineModifiedInactive          = { guifg = M.c.inactive_text,        guibg = M.c.inactive_bg } ,
     TabLineCloseActive               = { guifg = M.c.active_text,          guibg = M.c.active_bg } ,
     TabLineCloseInactive             = { guifg = M.c.inactive_text,        guibg = M.c.inactive_bg } ,
})

return M
