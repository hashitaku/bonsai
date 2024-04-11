return {
    {
        "hrsh7th/vim-vsnip",
        enabled = not vim.g.vscode,
        config = function()
            vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
        end,
    },
}
