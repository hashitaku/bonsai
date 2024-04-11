return {
    {
        "folke/noice.nvim",
        enabled = not vim.g.vscode,
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            messages = {
                enabled = true,
                view = "notify",
            },
            presets = {
                command_palette = false,
            },
        },
    },
}
