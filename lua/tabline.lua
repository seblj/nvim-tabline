local M = {}
local icons = require('tabline.icons')
local utils = require('tabline.utils')
local opt
local fix_item_len, separator_len
local right_ext, left_ext, right_ext_len, left_ext_len

-- Return min_size, item
-- where min_size is the minimum size of the item
-- (i.e. if you call with max_len < min_size, you get back an item of min_size len)
-- and item is the item, ready to render
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
    local icon_len = utils.eval_len(modified_icon .. close_icon)
    if max_len then
        local tabname_len = utils.eval_len(tabname)
        local win_count_len = utils.eval_len(win_count)
        if (fix_item_len + tabname_len + win_count_len + icon_len) >= max_len then
            if win_count_len > 0 and (fix_item_len + 2 + win_count_len + icon_len) > max_len then
                win_count = ''
                win_count_len = 0
            end
            local trunc = max_len - fix_item_len - win_count_len - icon_len
            if trunc <= 0 then
                tabname = '..'
            elseif trunc < tabname_len then
                tabname = tabname:sub(1, trunc - 2) .. '..'
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
    return fix_item_len + 2 + icon_len, full_item
end

local truncated_line = function(active_idx, items, items_len, items_min_len, target, right_sep)
    local last_index = #items
    local target_len = {}

    local trunc_slope = opt.truncation_slope
    local start_item, end_item, idx = active_idx, active_idx, active_idx
    local jump_size = 1
    local jump_dir = active_idx < last_index and 1 or -1
    local start_jump_dir = jump_dir
    local run = 2

    target_len[active_idx] = items_len[active_idx]
    target = target - target_len[active_idx]
    local reach_start, reach_end = false, false
    -- Leave extra space for extension if we don't fit all tabs
    target = target - right_ext_len - left_ext_len

    -- This algo can get very inefficient with weird slopes, and I'm not 100% certain
    -- I did not miss some edge cases. Since having your editor frozen is extremely unpleasant,
    -- I leave this small security, breaking if it goes out of control
    local watchdog = 1000 * vim.o.columns

    while target > 0 do
        ::continue::
        watchdog = watchdog - 1
        if watchdog <= 0 then
            break
        end

        -- Jump left and right of active tab
        idx = idx + (jump_dir * jump_size)
        jump_size = jump_size + 1
        jump_dir = jump_dir * -1
        -- But reset to active a lot to favor bigger sizes around active tab
        -- (the slope basically controls each how many jumps we start over)
        if jump_dir ~= start_jump_dir and jump_size > run then
            idx = active_idx
            jump_dir = start_jump_dir
            jump_size = 1
            run = run + trunc_slope
        end
        if idx > last_index or idx < 1 then
            goto continue
        end

        -- if new item, check that we can fit the smallest version of it
        if target_len[idx] == nil then
            if target > items_min_len[idx] then
                target_len[idx] = items_min_len[idx]
                target = target - items_min_len[idx]
            else
                -- No more space for new item. If all present items are fully expended, we
                -- are stuck and abort
                local can_expand = false
                for i = start_item, end_item do
                    if items_len[i] > target_len[i] then
                        can_expand = true
                    end
                end
                if can_expand then
                    goto continue
                else
                    break
                end
            end
        end
        -- If we have chars left to add, we make the item bigger.
        if items_len[idx] > target_len[idx] then
            target_len[idx] = target_len[idx] + 1
            target = target - 1
        end

        -- Keep track of start and end item. Adapt target if we reach the limits
        -- since we don't need to print the arrows left or right anywore
        start_item = math.min(start_item, idx)
        end_item = math.max(end_item, idx)
        if not reach_start and start_item == 1 then
            reach_start = true
            target = target + left_ext_len
        end
        if not reach_end and end_item == last_index then
            reach_end = true
            target = target + right_ext_len
        end
    end

    -- Assemble final line
    local trunc_line = ''
    for i = 1, last_index do
        if target_len[i] ~= nil then
            local _, new_item = gen_item(i, target_len[i])
            trunc_line = trunc_line .. new_item
        end
    end

    -- If the algo failed to converge and break early, just center anyway
    if target > 0 then
        local r = math.floor(target / 2)
        local l = math.ceil(target / 2)
        trunc_line = string.rep(' ', r) .. trunc_line .. string.rep(' ', l)
    end
    -- Add extra tab indicators if needed
    if reach_start and reach_end then
        return trunc_line .. right_sep
    elseif reach_start then
        return trunc_line .. right_ext
    elseif reach_end then
        return left_ext .. trunc_line .. right_sep
    else
        return left_ext .. trunc_line .. right_ext
    end
end

local tabline = function()
    local last_index = vim.fn.tabpagenr('$')

    -- Generate all items, keep trace of size. Store the minimal len in case we need to truncate
    local items = {}
    local items_len = {}
    local items_min_len = {}
    local tot_len = 0
    for index = 1, last_index do
        local min_size, item = gen_item(index)
        items[index] = item
        local len = utils.eval_len(item)
        items_len[index] = len
        items_min_len[index] = min_size
        tot_len = tot_len + len
    end
    local right_sep = utils.get_hl('TablineSeparator', opt.right_separator and opt.separator or '')
    local right_sep_len = utils.eval_len(right_sep)
    tot_len = tot_len + right_sep_len

    local full_line = ''
    if tot_len > vim.o.columns then
        local active_idx = vim.fn.tabpagenr()
        local target = vim.o.columns - right_sep_len
        full_line = truncated_line(active_idx, items, items_len, items_min_len, target, right_sep)
    else
        full_line = table.concat(items) .. right_sep
    end

    return full_line
end

M.setup = function(user_options)
    local config = require('tabline.config')
    opt = config.set(user_options)

    -- Compute fixed but config dependent stuff once
    separator_len = utils.eval_len(opt.separator .. string.rep(' ', opt.padding))
    fix_item_len = separator_len + (opt.show_icon and 2 or 0) + opt.padding

    right_ext = opt.tab_on_right_icon
    right_ext_len = utils.eval_len(right_ext)
    left_ext = opt.tab_on_left_icon
    left_ext_len = utils.eval_len(left_ext)

    function _G.nvim_tabline()
        return tabline()
    end

    vim.opt.tabline = '%!v:lua.nvim_tabline()'
    vim.g.loaded_nvim_tabline = 1
end

return M
