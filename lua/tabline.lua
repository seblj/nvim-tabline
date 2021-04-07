local M = {}
local fn = vim.fn
local hl = require('tabline.highlights')
local icons = require('tabline.icons')
local opt = require('tabline.config').options
local utils = require('tabline.utils')

local function tabline(options)
    local s = ''
    for index = 1, fn.tabpagenr('$') do
        local winnr = fn.tabpagewinnr(index)
        local buflist = fn.tabpagebuflist(index)
        local bufnr = buflist[winnr]
        local bufname = fn.bufname(bufnr)
        local bufmodified = fn.getbufvar(bufnr, "&mod")
        local filename = utils.find_filename(bufname)
        local extension = fn.fnamemodify(bufname, ':e')
        local prefix, suffix = utils.find_affixes()
        local left_separator, right_separator, devicon, close_icon, modified_icon

        -- Make clickable
        s = s .. '%' .. index .. 'T'

        if index == vim.fn.tabpagenr() then
            filename = hl.get_item(opt.highlights.filename_active.hl, filename)
            left_separator = hl.get_item(opt.highlights.separator_active.hl, options.separator)
            prefix = hl.get_item(opt.highlights.padding_active.hl, prefix)
            suffix = hl.get_item(opt.highlights.padding_active.hl, suffix)
        else
            filename = hl.get_item(opt.highlights.filename_inactive.hl, filename)
            left_separator = hl.get_item(opt.highlights.separator_inactive.hl, options.separator)
            prefix = hl.get_item(opt.highlights.padding_inactive.hl, prefix)
            suffix = hl.get_item(opt.highlights.padding_inactive.hl, suffix)
        end

        right_separator = utils.get_right_separator(index, opt.highlights.separator_inactive.hl, options.separator)
        devicon = icons.get_devicon(index, filename, extension, options.color_all_icons)
        modified_icon = icons.get_modified_icon(index, bufmodified, options.modified_icon)
        close_icon = icons.get_close_icon(index, bufmodified, options.close_icon)

        -- Assemble tabline
        s = s .. left_separator .. prefix .. devicon .. filename .. suffix .. modified_icon .. close_icon .. right_separator
    end
    return s
end

function M.setup(user_options)
    opt = vim.tbl_extend('force', opt, user_options)

    function _G.nvim_tabline()
        return tabline(opt)
    end

    if opt.always_show_tabs then
        vim.o.showtabline = 2
    else
        vim.o.showtabline = 1
    end
    vim.o.tabline = "%!v:lua.nvim_tabline()"

    vim.g.loaded_nvim_tabline = 1
end

return M
