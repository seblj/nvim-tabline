local M = {}

M.set_tabname = function()
    vim.ui.input({ prompt = 'Tabname: ' }, function(input)
        local tabnr = vim.fn.tabpagenr()
        vim.fn.settabvar(tabnr, 'TablineTitle', input)
    end)
    vim.cmd('redrawtabline')
end

M.clear_tabname = function()
    local tabnr = vim.fn.tabpagenr()
    vim.fn.settabvar(tabnr, 'TablineTitle', '')
    vim.cmd('redrawtabline')
end

return M
