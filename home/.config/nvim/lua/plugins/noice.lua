return {
    {
        "folke/noice.nvim",
        cond = not vim.g.vscode,
        opts = {
            messages = {
                enabled = true,
                view = "notify",
            },
            commands = {
                history = {
                    opts = {
                        scrollbar = false,
                    },
                },
                last = {
                    opts = {
                        scrollbar = false,
                    },
                },
                errors = {
                    opts = {
                        scrollbar = false,
                    },
                },
                all = {
                    opts = {
                        scrollbar = false,
                    },
                },
            },
            presets = {
                command_palette = false,
                lsp_doc_border = false,
            },
            lsp = {
                hover = {
                    enabled = false,
                },
                signature = {
                    enabled = false,
                },
                messages = {
                    enabled = false,
                },
            },
        },
    },
}
