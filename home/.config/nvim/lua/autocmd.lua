vim.api.nvim_create_autocmd('TermOpen', {
    callback = function()
        vim.opt_local['number'] = false
        vim.api.nvim_command('startinsert')
    end
})

vim.api.nvim_create_autocmd('TermClose', {
    callback = function() vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), {force = true}) end
})
