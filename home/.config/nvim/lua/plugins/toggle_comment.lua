return {
    {
        "toggle_comment.nvim",
        dir = "lua/toggle_comment.nvim",
        dev = true,
        opts = {},
        keys = {
            {
                "<C-_>",
                mode = {
                    "n",
                    "x"
                },
                "<CMD>ToggleComment<CR>",
            }
        }
    }
}
