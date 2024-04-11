return {
    {
        "lambdalisue/nerdfont.vim",
        enabled = not vim.g.vscode,
        config = function()
            vim.g["nerdfont#autofix_cellwidths"] = false
        end,
    },
}
