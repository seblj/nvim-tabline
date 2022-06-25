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
}

local config = {}

M.set = function(user_options)
    config = vim.tbl_extend('force', default, user_options or {})
    return config
end

M.get = function(key)
    if key and config[key] ~= nil then
        return config[key]
    end
    return config
end

return M
