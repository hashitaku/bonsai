return {
    {
        "neovim/nvim-lspconfig",
        cond = not vim.g.vscode,
        event = "LspAttach",
    },
}
