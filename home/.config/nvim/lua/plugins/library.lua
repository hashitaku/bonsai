return {
    {
        "folke/lazydev.nvim",
        cond = not vim.g.vscode,
        ft = "lua",
    },

    {
        "MunifTanjim/nui.nvim",
        cond = not vim.g.vscode,
    },

    {
        "nvim-lua/plenary.nvim",
        cond = not vim.g.vscode,
    },
}
