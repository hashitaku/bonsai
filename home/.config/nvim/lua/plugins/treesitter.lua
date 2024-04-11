return {
    {
        "nvim-treesitter/nvim-treesitter",
        enabled = not vim.g.vscode,
        config = function()
            vim.opt.foldlevelstart = 1
            vim.opt.foldmethod = "expr"
            vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
            vim.opt.foldtext = ""

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

    {
        "nvim-treesitter/playground",
        enabled = not vim.g.vscode,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },
}
