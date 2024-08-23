return {
    {
        "folke/noice.nvim",
        enabled = not vim.g.vscode,
        dependencies = {
            "MunifTanjim/nui.nvim",
            "rcarriga/nvim-notify",
        },
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
