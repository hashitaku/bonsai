return {
    {
        "toggle_comment.nvim",
        dir = vim.fs.joinpath(vim.fn.stdpath("config"), "lua", "toggle_comment.nvim"),
        dev = true,
        opts = {},
        keys = {
            {
                "<C-_>",
                mode = {
                    "n",
                    "x",
                },
                function()
                    require("toggle_comment.core").toggle_comment()
                end,
            },
        },
    },
}
