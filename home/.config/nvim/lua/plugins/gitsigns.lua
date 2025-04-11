return {
    {
        "lewis6991/gitsigns.nvim",
        cond = not vim.g.vscode,
        opts = {
            preview_config = {
                border = "rounded",
            },
        },
    },
}
