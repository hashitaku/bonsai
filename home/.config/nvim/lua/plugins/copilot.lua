return {
    {
        "zbirenbaum/copilot.lua",
        cond = not vim.g.vscode,
        opts = {
            suggestion = { enabled = false },
            panel = { enabled = false },
        },
    },
}
