local M = {}
local icons = require('tabline.icons')
local utils = require('tabline.utils')
local opt

local gen_item = function(index)
    local winnr = vim.fn.tabpagewinnr(index)
    local bufnr = vim.fn.tabpagebuflist(index)[winnr]
    local bufname = vim.fn.bufname(bufnr)
    local bufmodified = vim.fn.getbufvar(bufnr, '&mod') == 1
    local tabname = utils.get_tabname(bufname, index)
    local extension = vim.fn.fnamemodify(bufname, ':e')
    local tabpage_handle = vim.api.nvim_list_tabpages()[index]

    local win_count = opt.show_window_count.enable and utils.get_win_count(tabpage_handle) or ''
    local padding = string.rep(' ', opt.padding)
    local left_sep = opt.separator
    local modified_icon = bufmodified and opt.modified_icon .. ' ' or ''
    local close_icon = not bufmodified and opt.close_icon or ''
    if close_icon and close_icon ~= '' then
        local hl_icon = utils.get_hl('TabLineClose', close_icon, index, bufmodified)
        close_icon = '%' .. index .. 'X' .. hl_icon .. '%X '
    end

    if opt.show_index then
        tabname = index .. ' ' .. tabname
    end

    -- stylua: ignore
    local tabline_items = {
        utils.get_hl('TabLineSeparator', left_sep, index),            -- Left separator
        utils.get_hl('TabLinePadding', padding, index),               -- Padding
        icons.get_devicon(index, bufname, extension),                   -- DevIcon
        utils.get_hl('TabLine', tabname, index),                      -- Tabname (default to filename)
        utils.get_hl('TabLine', win_count, index),                    -- window count
        utils.get_hl('TabLinePadding', padding, index),               -- Padding
        utils.get_hl('TabLine', modified_icon, index, bufmodified),   -- Modified icon
        close_icon,                                                   -- Closing icon
    }
    -- makes tab clickable
    return '%' .. index .. 'T' .. table.concat(tabline_items) .. '%T'
end

local tabline = function()
    local last_index = vim.fn.tabpagenr('$')

    local s = ''
    for index = 1, last_index do
        local item = gen_item(index)

        local right_sep = index == last_index and opt.right_separator and opt.separator or ''
        s = s .. item .. utils.get_hl('TabLineSeparator', right_sep)
    end
    return s
end

M.setup = function(user_options)
    local config = require('tabline.config')
    opt = config.set(user_options)
    function _G.nvim_tabline()
        return tabline()
    end

    vim.opt.tabline = '%!v:lua.nvim_tabline()'
    vim.g.loaded_nvim_tabline = 1
end

return M
