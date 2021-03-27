local M = {}
local fn = vim.fn
local hl = require('highlights')
local icons = require('icons')

M.options = {
    no_name = '[No Name]',
    modified_icon = '',
    separator = '▐',
    space = 3,
    color_all_icons = false,
    always_show_tabs = false
}

local function find_affixes(modified)
    local prefix = string.rep(' ', M.options.space)
    local suffix
    if modified == 1 then
        suffix = string.rep(' ', M.options.space - fn.strchars(M.options.modified_icon))
    else
        suffix = string.rep(' ', M.options.space)
    end
    return prefix, suffix
end

local function get_modified_icon(modified)
    if modified == 1 then
        return hl.get_hl_item(hl.string_active, M.options.modified_icon)
    else
        return ''
    end
end


local function tabline(options)
    local s = ''
    for index = 1, fn.tabpagenr('$') do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, "&mod")
        local filename = fn.fnamemodify(bufname, ':t')
        local extension = fn.fnamemodify(bufname, ':e')
        local devicon = icons.get_icon(filename, extension, true)
        local separator = ''
        local prefix, suffix = find_affixes(bufmodified)
        local modified_icon = get_modified_icon(bufmodified)
        local padding = ' '

        -- Use no-name option if bufname is empty
        if bufname == '' then
            filename = options.no_name
        end

        -- Make clickable
        s = s .. '%' .. index .. 'T'

        -- Get items based on selected tab or not
        if index == fn.tabpagenr() then
            filename = hl.get_hl_item(hl.string_active, filename)
            separator = hl.get_hl_item(hl.separator_active, options.separator)
        else
            separator = hl.get_hl_item(hl.separator_inactive, options.separator)
            if not options.color_all_icons then
                devicon = icons.get_icon(filename, extension, false)
            end
        end
        filename = filename .. padding

        -- Assemble tabline
        s = s .. separator .. prefix .. devicon .. filename .. modified_icon .. suffix

    end
    s = s .. '%#TabLineFill#'
    return s
end

function M.setup(user_options)
    M.options = vim.tbl_extend('force', M.options, user_options)

    function _G.nvim_tabline()
        return tabline(M.options)
    end

    if M.options.always_show_tabs then
        vim.o.showtabline = 2
    else
        vim.o.showtabline = 1
    end
    vim.o.tabline = "%!v:lua.nvim_tabline()"

    vim.g.loaded_nvim_tabline = 1
end

return M
