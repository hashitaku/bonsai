return {
    {
        "stevearc/oil.nvim",
        cond = not vim.g.vscode,
        opts = {
            win_options = {
                number = false,
                signcolumn = "yes:2",
            },
            view_options = {
                show_hidden = true,
                is_always_hidden = function(name, bufnr)
                    if vim.startswith(name, "..") then
                        return true
                    end

                    return false
                end,
            },
            float = {
                max_width = 0.8,
                max_height = 0.8,
                win_options = {
                    winblend = 10,
                },
            },
        },
        -- 遅延ロードすると`nvim .`のような開き方でOilが読み込まれないため
        lazy = false,
        keys = {
            {
                "<C-n>",
                mode = {
                    "n",
                },
                function()
                    local oil = require("oil")
                    oil.toggle_float()
                end,
            },
        },
    },

    {
        "refractalize/oil-git-status.nvim",
        cond = not vim.g.vscode,
        opts = {},
        dependencies = {
            "stevearc/oil.nvim",
        },
    },
}
