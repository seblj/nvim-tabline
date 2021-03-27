local M = {}
local ok, web = pcall(require, 'nvim-web-devicons')

-- Find correct color
function M.get_attr(group, attr)
  local rgb_val = (vim.api.nvim_get_hl_by_name(group, true) or {})[attr]
  return rgb_val and string.format('#%06x', rgb_val) or 'NONE'
end

-- Return icon with fg color
function M.get_icon(name, extension, colored)
    local icon
    local icon_hl
    if ok then
        icon, icon_hl = web.get_icon(name, extension, { default = true })
        if not colored then
            return icon .. ' '
        end
    else
        return ''
    end
    icon = icon .. ' '
    local color = M.get_attr(icon_hl, 'foreground')

    vim.cmd(
        'highlight ' .. icon_hl ..
        ' guifg=' .. color
    )
    return '%#' .. icon_hl .. '#' .. icon .. '%*'
end

return M
