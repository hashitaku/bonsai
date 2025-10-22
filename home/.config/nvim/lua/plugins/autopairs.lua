return {
    {
        "windwp/nvim-autopairs",
        cond = not vim.g.vscode,
        config = function()
            local npairs = require("nvim-autopairs")

            npairs.setup({
                check_ts = true,
            })

            npairs.get_rules("`")[1].not_filetypes = { "ps1" }
        end,
    },
}
