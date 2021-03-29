local M = {}
local opt = require('tabline.config').options
local colors = opt.colors
local active = 'Active'
local inactive = 'Inactive'

M.filename = 'TablineFilename'
M.padding = 'TablinePadding'
M.separator = 'TablineSeparator'
M.modified_icon = 'TablineModified'
M.close_icon = 'TablineClose'
M.fill = 'TablineFill'

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

function M.get_hl_item(index, group, item)
    if index == vim.fn.tabpagenr() then
        group = group .. active
    else
        group = group .. inactive
    end
    return '%#'  .. group .. '#' .. item .. '%*'
end


-- General
M.set_one(M.fill, {guifg = colors.inactive_background, guibg = colors.inactive_background})

-- Active tab
M.set_one(M.filename .. active, {guifg = colors.active_filename, guibg = colors.active_background, gui = 'bold,italic'})
M.set_one(M.separator .. active, {guifg = colors.active_sep, guibg = colors.active_background})
M.set_one(M.padding .. active, {guifg = colors.acitve_background, guibg = colors.active_background})
M.set_one(M.modified_icon .. active, {guifg = colors.active_mod_icon, guibg = colors.active_background})
M.set_one(M.close_icon .. active, {guifg = colors.active_close_icon, guibg = colors.active_background})

-- Inactive tab
M.set_one(M.filename .. inactive, {guifg = colors.inactive_filename, guibg = colors.inactive_background})
M.set_one(M.separator .. inactive, {guifg = colors.inactive_sep, guibg = colors.inactive_background})
M.set_one(M.padding .. inactive, {guifg = colors.inactive_background, guibg = colors.inactive_background})
M.set_one(M.modified_icon .. inactive, {guifg = colors.inactive_mod_icon, guibg = colors.inactive_background})
M.set_one(M.close_icon .. inactive, {guifg = colors.inactive_close_icon, guibg = colors.inactive_background})


return M
