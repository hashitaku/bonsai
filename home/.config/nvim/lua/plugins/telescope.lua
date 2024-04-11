return {
    {
        "nvim-telescope/telescope.nvim",
        enabled = not vim.g.vscode,
        keys = {
            {
                "<Leader>p",
                mode = {
                    "n",
                },
                function()
                    require("telescope.builtin").find_files()
                end,
            },
        }
    },
}
