return {
    {
        "rust-lang/rust.vim",
        enabled = not vim.g.vscode,
        ft = "rust",
        config = function()
            vim.g.rustfmt_autosave = true
        end,
    },
}
