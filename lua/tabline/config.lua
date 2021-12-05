local M = {}

local default = {
    no_name = '[No Name]',
    modified_icon = '',
    close_icon = '',
    separator = '▌',
    padding = 3,
    color_all_icons = false,
    always_show_tabs = false,
    right_separator = false,
    show_index = false,
    show_icon = true,
}

local config = {}

M.set = function(user_options)
    user_options = user_options or {}
    config = vim.tbl_extend('force', default, user_options)
    return config
end

M.get = function(key)
    if key then
        return config[key]
    end
    return config
end

return M
