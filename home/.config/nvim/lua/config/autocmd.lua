vim.api.nvim_create_autocmd("QuickFixCmdPost", {
    command = "cwindow",
})

vim.api.nvim_create_autocmd("TermOpen", {
    callback = function(_)
        vim.cmd.startinsert()
    end,
})
