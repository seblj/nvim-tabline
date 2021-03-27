local M = {}

M.string_active = 'TablineString'
M.separator_active = 'TablineSeparator'
M.separator_inactive = 'TablineSeparatorInactive'

M.colors = {
    background = '#1c1c1c',
    text = '#eeeeee',
    red = '#ff6077',
    grey = '#7f8490'
}

function M.set_one(name, opts)
    if opts and vim.tbl_count(opts) > 0 then
        local high = "highlight! " .. name
        if opts.gui and opts.gui ~= "" then
            high = high .. " " .. "gui=" .. opts.gui
        end
        if opts.guifg and opts.guifg ~= "" then
            high = high .. " " .. "guifg=" .. opts.guifg
        end
        if opts.guibg and opts.guibg ~= "" then
            high = high .. " " .. "guibg=" .. opts.guibg
        end
        if opts.guisp and opts.guisp ~= "" then
            high = high .. " " .. "guisp=" .. opts.guisp
        end
        local success, err = pcall(vim.api.nvim_command, high)
        if not success then
            vim.api.nvim_err_writeln(
            "Failed setting " ..
            name .. " highlight, something isn't configured correctly" .. "\n" .. err
            )
        end
    end
end

function M.get_hl_item(group, item)
    return '%#'  .. group .. '#' .. item .. '%*'
end

M.set_one(M.string_active, {guifg = M.colors.text, guibg = M.colors.background, gui = 'bold,italic'})
M.set_one(M.separator_active, {guifg = M.colors.red})
M.set_one(M.separator_inactive, {guifg = M.colors.grey})

return M
