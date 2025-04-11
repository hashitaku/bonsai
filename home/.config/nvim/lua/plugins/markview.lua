return {
    {
        "OXY2DEV/markview.nvim",
        cond = not vim.g.vscode,
        ft = "markdown",
        ---@type mkv.config
        opts = {
            preview = {
                enable = false,
            },
        },
    },
}
