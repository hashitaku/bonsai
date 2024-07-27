return {
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = not vim.g.vscode,
        config = function()
            vim.api.nvim_set_option_value("foldlevelstart", 1, {})
            vim.api.nvim_set_option_value("foldmethod", "expr", {})
            vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", {})
            vim.api.nvim_set_option_value("foldtext", "", {})

            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "bash",
                    "c",
                    "c_sharp",
                    "cmake",
                    "cpp",
                    "css",
                    "html",
                    "json",
                    "lua",
                    "make",
                    "markdown",
                    "markdown_inline",
                    "meson",
                    "python",
                    "regex",
                    "rust",
                    "slint",
                    "toml",
                    "typescript",
                    "vim",
                    "vimdoc",
                    "yaml",
                },
                sync_intall = true,
                highlight = {
                    enable = true,
                },
            })
        end,
    },
}
