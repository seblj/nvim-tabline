local M = {}
local opt = require('tabline.config').options
local highlights = opt.highlights

-- https://github.com/akinsho/nvim-bufferline.lua/blob/master/lua/bufferline/highlights.lua
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

-- Highlights item with the color of group
function M.get_item(group, item)
    return group .. item .. '%*'
end

-- Create a highlights using name
function M.create_hl_group(name)
    return '%#' .. name .. '#'
end

-- Set all colors from highlights in config
function M.set_all()
    for name, tbl in pairs(highlights) do
        -- Converts snake case to pascal
        local formatted = "Tabline" .. name:gsub("_(.)", name.upper):gsub("^%l", string.upper)
        M.set_one(formatted, tbl)
        -- Set highlight group inside table for access when getting items
        highlights[name]['hl'] = M.create_hl_group(formatted)
    end
end

M.set_all()

vim.cmd [[augroup TablineColors]]
vim.cmd [[autocmd!]]
vim.cmd [[autocmd ColorScheme * lua require('tabline.highlights').set_all()]]
vim.cmd [[augroup END]]

return M
