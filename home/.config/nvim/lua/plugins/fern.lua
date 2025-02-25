return {
    {
        "lambdalisue/fern-git-status.vim",
        enabled = not vim.g.vscode and false,
        dependencies = {
            "lambdalisue/fern.vim",
        },
    },

    {
        "lambdalisue/fern-hijack.vim",
        enabled = not vim.g.vscode and false,
        dependencies = {
            "lambdalisue/fern.vim",
        },
    },

    {
        "lambdalisue/fern-renderer-nerdfont.vim",
        enabled = not vim.g.vscode and false,
        dependencies = {
            "lambdalisue/fern.vim",
            "lambdalisue/nerdfont.vim",
        },
    },

    {
        "lambdalisue/fern.vim",
        enabled = not vim.g.vscode and false,
        config = function()
            vim.g["fern#default_hidden"] = true
            vim.g["fern#drawer_keep"] = true
            vim.g["fern#renderer#nerdfont#indent_markers"] = true
            vim.g["fern#renderer#nerdfont#padding"] = " "
            vim.g["fern#renderer"] = "nerdfont"
            vim.keymap.set("n", "<C-n>", "<cmd>Fern . -reveal=% -drawer -toggle<cr>", {})

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "fern" },
                callback = function()
                    vim.opt_local.number = false
                    vim.opt_local.relativenumber = false
                    vim.opt_local.signcolumn = "auto"
                end,
            })
        end,
    },
}
