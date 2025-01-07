local M = {}

local default = {
    no_name = '[No Name]',
    modified_icon = '',
    close_icon = '',
    separator = '▌',
    padding = 3,
    color_all_icons = false,
    right_separator = false,
    show_index = false,
    show_icon = true,
    show_window_count = {
        enable = false,
        show_if_alone = false, -- do not show count if unique win in a tab
        count_unique_buf = true, -- count only win showing different buffers
        count_others = true, -- display [+x] where x is the number of other windows
        buftype_blacklist = { 'nofile' }, -- do not count if buftype among theses
    },
    -- Control the truncation algorithm.
    -- Big numbers will tend to show more tabs agressively trucated, while small number will
    -- tend to have less truncated tabs around active one at the cost of displaying less tabs.
    -- Caution : the algorithm is iterative and becomes inefficient on both ends
    -- (i.e really big or really close to 0 slopes, keep between 0.01 and 100)
    truncation_slope = 0.8,
    tab_on_right_icon = ' >',
    tab_on_left_icon = '< ',
}

local config = {}

M.set = function(user_options)
    config = vim.tbl_deep_extend('force', default, user_options or {})
    return config
end

M.get = function(key)
    if key and config[key] ~= nil then
        return config[key]
    end
    return config
end

return M
