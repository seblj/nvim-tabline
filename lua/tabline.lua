local M = {}
local config = require('tabline.config')
local opt

local tabline = function()
    local icons = require('tabline.icons')
    local utils = require('tabline.utils')

    local s = ''
    for index = 1, vim.fn.tabpagenr('$') do
        local winnr = vim.fn.tabpagewinnr(index)
        local bufnr = vim.fn.tabpagebuflist(index)[winnr]
        local bufname = vim.fn.bufname(bufnr)
        local bufmodified = vim.fn.getbufvar(bufnr, '&mod')
        local tabname = utils.get_tabname(bufname, index)
        local extension = vim.fn.fnamemodify(bufname, ':e')
        local padding = string.rep(' ', opt.padding)

        if opt.show_index then
            tabname = index .. ' ' .. tabname
        end

        -- Make clickable
        s = s .. '%' .. index .. 'T'

        local active = index == vim.fn.tabpagenr()

        -- stylua: ignore
        local tabline_items = {
            icons.get_left_separator(active, bufmodified),                   -- Left separator
            utils.get_item('TabLinePadding', padding, active),               -- Padding
            icons.get_devicon(active, bufname, extension),                   -- DevIcon
            utils.get_item('TabLine', tabname, active, true),                -- Tabname (default to filename)
            utils.get_item('TabLinePadding', padding, active),               -- Padding
            icons.get_modified_icon('TabLineModified', active, bufmodified), -- Modified icon
            icons.get_close_icon('TabLineClose', index, bufmodified),        -- Closing icon
            icons.get_right_separator('TabLineSeparator', index),            -- Rigth separator
        }
        s = s .. table.concat(tabline_items)
    end
    return s
end

M.setup = function(user_options)
    opt = config.set(user_options)
    function _G.nvim_tabline()
        return tabline()
    end

    if opt.always_show_tabs then
        vim.opt.showtabline = 2
    else
        vim.opt.showtabline = 1
    end
    vim.opt.tabline = '%!v:lua.nvim_tabline()'

    vim.g.loaded_nvim_tabline = 1
end

return M
