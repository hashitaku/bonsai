return {
    {
        "Saghen/blink.cmp",
        build = "cargo build --release",
        cond = not vim.g.vscode and false,
        lazy = false,
        dependencies = {
            "fang2hou/blink-copilot",
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
                default = { "lsp", "buffer", "snippets", "path", "copilot" },
                providers = {
                    copilot = {
                        name = "copilot",
                        module = "blink-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
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

    {
        "fang2hou/blink-copilot",
        cond = not vim.g.vscode and false,
        opts = {},
    }
}
