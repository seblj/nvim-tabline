local M = {}

M.set_tabname = function()
    vim.ui.input({ prompt = 'Tabname: ' }, function(input)
        local tabnr = vim.fn.tabpagenr()
        vim.fn.settabvar(tabnr, 'TablineTitle', input)
    end)
end

M.clear_tabname = function()
    local tabnr = vim.fn.tabpagenr()
    vim.fn.settabvar(tabnr, 'TablineTitle', '')
end

return M
