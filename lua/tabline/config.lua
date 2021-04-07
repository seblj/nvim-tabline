local M = {}

M.active_background = '#1c1c1c'
M.inactive_background = '#121212'
M.active_text = '#eeeeee'
M.inactive_text = '#7f8490'
M.active_separator = '#ff6077'

M.options = {
    no_name = '[No Name]',
    modified_icon = '',
    close_icon = '',
    separator = "▌",
    space = 3,
    color_all_icons = false,
    always_show_tabs = false,
    right_separator = false,
    highlights = {
        fill = {
            guifg = M.inactive_background,
            guibg = M.inactive_background
        },
        filename_active = {
            guifg = M.active_text,
            guibg = M.active_background,
            gui = 'bold,italic'
        },
        filename_inactive = {
            guifg = M.inactive_text,
            guibg = M.inactive_background
        },
        padding_active = {
            guifg = M.active_background,
            guibg = M.active_background
        },
        padding_inactive = {
            guifg = M.inactive_background,
            guibg = M.inactive_background
        },
        separator_active = {
            guifg = M.active_separator,
            guibg = M.active_background
        },
        separator_inactive = {
            guifg = M.inactive_text,
            guibg = M.inactive_background
        },
        modified_active = {
            guifg = M.active_text,
            guibg = M.active_background
        },
        modified_inactive = {
            guifg = M.inactive_text,
            guibg = M.inactive_background
        },
        close_active = {
            guifg = M.active_text,
            guibg = M.active_background
        },
        close_inactive = {
            guifg = M.inactive_text,
            guibg = M.inactive_background
        }
    }
}

return M
