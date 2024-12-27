local M = {}
local config = require('tabline.config')
local opt

local tabline = function()
    local icons = require('tabline.icons')
    local utils = require('tabline.utils')
    local last_index = vim.fn.tabpagenr('$')

    local s = ''
    for index, tabpage_handle in pairs(vim.api.nvim_list_tabpages()) do
        local winnr = vim.fn.tabpagewinnr(index)
        local bufnr = vim.fn.tabpagebuflist(index)[winnr]
        local bufname = vim.fn.bufname(bufnr)
        local bufmodified = vim.fn.getbufvar(bufnr, '&mod') == 1
        local tabname = utils.get_tabname(bufname, index)
        local extension = vim.fn.fnamemodify(bufname, ':e')

        local win_count = config.get('show_window_count').enable and utils.get_win_count(tabpage_handle) or ''
        local padding = string.rep(' ', opt.padding)
        local left_sep = config.get('separator')
        local right_sep = index == last_index and config.get('right_separator') and left_sep or ''
        local modified_icon = bufmodified and config.get('modified_icon') .. ' ' or ''
        local close_icon = config.get('close_icon')

        if opt.show_index then
            tabname = index .. ' ' .. tabname
        end

        -- Make clickable
        s = s .. '%' .. index .. 'T'

        -- stylua: ignore
        local tabline_items = {
            utils.get_item('TabLineSeparator', left_sep, index),            -- Left separator
            utils.get_item('TabLinePadding', padding, index),               -- Padding
            icons.get_devicon(index, bufname, extension),                   -- DevIcon
            utils.get_item('TabLine', tabname, index),                      -- Tabname (default to filename)
            utils.get_item('TabLine', win_count, index),                    -- window count
            utils.get_item('TabLinePadding', padding, index),               -- Padding
            utils.get_item('TabLine', modified_icon, index, bufmodified),   -- Modified icon
            utils.get_item('TabLineClose', close_icon, index, bufmodified), -- Closing icon
            utils.get_item('TabLineSeparator', right_sep),                  -- Right separator
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

    vim.opt.tabline = '%!v:lua.nvim_tabline()'
    vim.g.loaded_nvim_tabline = 1
end

return M
