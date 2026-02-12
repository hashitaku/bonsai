return {
    {
        "nvim-treesitter/nvim-treesitter",
        cond = not vim.g.vscode,
        branch = "main",
        config = function()
            local parser = {
                "bash",
                "c",
                "c_sharp",
                "cmake",
                "cpp",
                "css",
                "go",
                "html",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "meson",
                "powershell",
                "python",
                "regex",
                "rust",
                "slint",
                "toml",
                "typescript",
                "typst",
                "vim",
                "vimdoc",
                "yaml",
            }

            require("nvim-treesitter").install(parser)

            local user_treesitter_augid = vim.api.nvim_create_augroup("user_treesitter", { clear = false })
            vim.api.nvim_create_autocmd({ "FileType" }, {
                group = user_treesitter_augid,
                callback = function(ev)
                    if vim.list_contains(parser, ev.match) then
                        local success, result = pcall(vim.treesitter.start)

                        vim.api.nvim_set_option_value("foldlevelstart", 1, {})
                        vim.api.nvim_set_option_value("foldmethod", "expr", {})
                        vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", {})
                        vim.api.nvim_set_option_value("foldtext", "", {})
                    end

                end,
            })
        end,
    },
}
