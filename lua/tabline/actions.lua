local M = {}

M.set_tabname = function()
    vim.ui.input({ prompt = 'Tabname: ' }, function(input)
        if not input then
            return
        end
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
