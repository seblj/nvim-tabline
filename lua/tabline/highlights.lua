local M = {}

-- Highlights item with the color of group
function M.get_item(group, item)
    return group .. item .. '%*'
end

-- Create a highlights using name
function M.create_hl_group(name)
    return '%#' .. name .. '#'
end

M.highlight = function(name, opts)
    if not opts.guisp then
        opts.guisp = 'NONE'
    end
    if not opts.gui then
        opts.gui = 'NONE'
    end
    if name and vim.tbl_count(opts) > 0 then
        if opts.link and opts.link ~= '' then
            vim.cmd('highlight!' .. ' link ' .. name .. ' ' .. opts.link)
        else
            local command = { 'highlight!', name }
            for k, v in pairs(opts) do
                table.insert(command, string.format('%s=', k) .. v)
            end
            vim.cmd(table.concat(command, ' '))
        end
    end
end

M.highlight_all = function(hls)
    for _, hl in ipairs(hls) do
        M.highlight(unpack(hl))
    end
end

M.c = {
    active_bg = '#1c1c1c',
    inactive_bg = '#121212',
    active_text = '#eeeeee',
    inactive_text = '#7f8490',
    active_sep = '#ff6077',
}

M.highlight_all({
    { 'TablineFill', { guifg = M.c.inactive_bg, guibg = M.c.inactive_bg } },
    { 'TablineFilenameActive', { guifg = M.c.active_text, guibg = M.c.active_bg, gui = 'bold,italic' } },
    { 'TablineFilenameInactive', { guifg = M.c.inactive_text, guibg = M.c.inactive_bg } },
    { 'TablineSeparatorActive', { guifg = M.c.active_sep, guibg = M.c.active_bg } },
    { 'TablineSeparatorInactive', { guifg = M.c.inactive_text, guibg = M.c.inactive_bg } },
    { 'TablinePaddingActive', { guifg = M.c.active_bg, guibg = M.c.active_bg } },
    { 'TablinePaddingInactive', { guifg = M.c.inactive_bg, guibg = M.c.inactive_bg } },
    { 'TablineModifiedActive', { guifg = M.c.active_text, guibg = M.c.active_bg } },
    { 'TablineModifiedInactive', { guifg = M.c.inactive_text, guibg = M.c.inactive_bg } },
    { 'TablineCloseActive', { guifg = M.c.active_text, guibg = M.c.active_bg} },
    { 'TablineCloseInactive', { guifg = M.c.inactive_text, guibg = M.c.inactive_bg} },
})

-- Set all colors from highlights in config
-- function M.set_all()
--     for name, tbl in pairs(highlight_groups) do
--         -- Converts snake case to pascal
--         -- local formatted = "Tabline" .. name:gsub("_(.)", name.upper):gsub("^%l", string.upper)
--         M.set_one(name, tbl)
--         -- Set highlight group inside table for access when getting items
--         -- highlights[name]['hl'] = M.create_hl_group(formatted)
--     end
-- end

-- M.set_all()



-- vim.cmd [[augroup TablineColors]]
-- vim.cmd [[autocmd!]]
-- vim.cmd [[autocmd ColorScheme * lua require('tabline.highlights').set_all()]]
-- vim.cmd [[augroup END]]

return M
