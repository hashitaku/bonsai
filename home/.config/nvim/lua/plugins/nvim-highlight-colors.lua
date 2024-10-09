return {
    {
        "brenoprata10/nvim-highlight-colors",
        enabled = not vim.g.vscode,
        config = function()
            require("nvim-highlight-colors").setup({
                render = "virtual",
                virtual_symbol = "󱓻",
                virtual_symbol_prefix = "",
                virtual_symbol_suffix = "",
                virtual_symbol_position = "eol",
                exclude_filetypes = {
                    "lazy",
                },
            })

            vim.api.nvim_create_autocmd({ "InsertEnter" }, {
                callback = function()
                    require("nvim-highlight-colors").turnOff()
                end,
            })

            vim.api.nvim_create_autocmd({ "InsertLeave" }, {
                callback = function()
                    require("nvim-highlight-colors").turnOn()
                end,
            })
        end,
    },
}
