return {
    {
        "OXY2DEV/markview.nvim",
        enabled = not vim.g.vscode,
        ---@type mkv.config
        opts = {
            preview = {
                enable = false,
            },
        },
    },
}
