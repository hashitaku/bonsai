return {
    {
        "folke/noice.nvim",
        cond = not vim.g.vscode,
        opts = {
            messages = {
                enabled = true,
                view = "notify",
            },
            presets = {
                command_palette = false,
                lsp_doc_border = true,
            },
            lsp = {
                signature = {
                    enabled = false,
                },
            },
        },
    },
}
