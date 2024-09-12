return {
    {
        "folke/noice.nvim",
        enabled = not vim.g.vscode,
        opts = {
            messages = {
                enabled = true,
                view = "notify",
            },
            presets = {
                command_palette = false,
                lsp_doc_border = true,
            },
        },
    },
}
