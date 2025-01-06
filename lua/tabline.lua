local M = {}
local icons = require('tabline.icons')
local utils = require('tabline.utils')
local opt
local fix_item_len

-- Return one tab item, optionally truncated with max_len (in columns).
-- Minimal size depends on config and modified icon in such a way that we cannot
-- garentee the final size.
local gen_item = function(index, max_len)
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

    -- Compute length and adapt if necessary
    if max_len then
        local tabname_len = utils.eval_len(tabname)
        local win_count_len = utils.eval_len(win_count)
        local icon_len = utils.eval_len(modified_icon .. close_icon)
        if (fix_item_len + tabname_len + win_count_len + icon_len) >= max_len then
            if (fix_item_len + 2 + win_count_len + icon_len) >= max_len and win_count_len > 0 then
                win_count = ''
                win_count_len = 0
            end
            local trunc = max_len - fix_item_len - win_count_len - icon_len
            if trunc <= 0 then
                tabname = '..'
            else
                tabname = tabname:sub(1, trunc) .. '..'
            end
        end
    end

    -- stylua: ignore
    local tabline_items = {
        utils.get_hl('TabLineSeparator', left_sep, index),            -- Left separator
        utils.get_hl('TabLinePadding', padding, index),               -- Padding
        icons.get_devicon(index, bufname, extension),                 -- DevIcon
        utils.get_hl('TabLine', tabname, index),                      -- Tabname (default to filename)
        utils.get_hl('TabLine', win_count, index),                    -- window count
        utils.get_hl('TabLinePadding', padding, index),               -- Padding
        utils.get_hl('TabLine', modified_icon, index, bufmodified),   -- Modified icon
        close_icon,                                                   -- Closing icon
    }
    -- makes tab clickable
    local full_item = '%' .. index .. 'T' .. table.concat(tabline_items) .. '%T'
    return full_item
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

    -- Compute fixed but config dependent size
    local sep_len = utils.eval_len(opt.separator .. string.rep(' ', opt.padding))
    fix_item_len = sep_len + (opt.show_icon and 2 or 0) + opt.padding
    if opt.close_icon ~= '' then
        fix_item_len = fix_item_len + utils.eval_len(opt.close_icon .. ' ')
    end

    function _G.nvim_tabline()
        return tabline()
    end

    vim.opt.tabline = '%!v:lua.nvim_tabline()'
    vim.g.loaded_nvim_tabline = 1
end

return M
