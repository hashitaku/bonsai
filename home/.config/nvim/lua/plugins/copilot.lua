return {
    {
        "zbirenbaum/copilot.lua",
        cond = not vim.g.vscode,
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },

    {
        "CopilotC-Nvim/CopilotChat.nvim",
        cond = not vim.g.vscode,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "zbirenbaum/copilot.lua",
        },
        opts = {},
    }
}
