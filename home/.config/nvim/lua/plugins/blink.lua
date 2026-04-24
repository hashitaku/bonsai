return {
    {
        "saghen/blink.lib",
        cond = not vim.g.vscode and false,
    },

    {
        "Saghen/blink.cmp",
        build = function()
            require("blink.cmp").build():wait(60000)
        end,
        cond = not vim.g.vscode and false,
        lazy = false,
        dependencies = {
            "Saghen/blink.cmp",
        },
        ---@module "blink.cmp"
        ---@type blink.cmp.Config
        opts = {
            cmdline = {
                completion = {
                    menu = {
                        auto_show = true,
                    },
                    list = {
                        selection = {
                            preselect = false,
                            auto_insert = true,
                        },
                    },
                },
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 50,
                    window = {
                        border = "rounded",
                    },
                },
                list = {
                    selection = {
                        preselect = false,
                        auto_insert = true,
                    },
                },
                menu = {
                    auto_show = true,
                    border = "rounded",
                    scrollbar = false,
                },
            },
            keymap = {
                preset = "none",
                ["<C-e>"] = { "cancel", "fallback" },
                ["<C-n>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback" },
                ["<Tab>"] = { "select_next", "fallback" },
                ["<S-Tab>"] = { "select_prev", "fallback" },
                ["<CR>"] = { "accept", "fallback" },
            },
            sources = {
                default = { "lsp", "buffer", "snippets", "path" },
            },
        },
        keys = {
            -- https://github.com/Saghen/blink.cmp/issues/453
            {
                "<C-x><C-o>",
                mode = {
                    "i",
                },
                function()
                    require("blink.cmp").show()
                end,
            },
        },
    },
}
