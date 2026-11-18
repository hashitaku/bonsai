return {
    {
        "nvim-treesitter/nvim-treesitter",
        cond = not vim.g.vscode,
        branch = "main",
        config = function()
            require("nvim-treesitter").install({
                "bash",
                "c",
                "c_sharp",
                "cmake",
                "cpp",
                "css",
                "go",
                "html",
                "javascript",
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
            })

            local user_treesitter_augid = vim.api.nvim_create_augroup("user_treesitter", { clear = false })
            vim.api.nvim_create_autocmd({ "FileType" }, {
                group = user_treesitter_augid,
                callback = function(ev)
                    local language = vim.treesitter.language.get_lang(ev.match)

                    -- neovim 0.12未満であればget_parserをerror = falseで呼び出す
                    local get_parser_opts = vim.version().major == 0 and vim.version().minor < 12 and { error = false } or {}
                    local parser = vim.treesitter.get_parser(ev.buf, language, get_parser_opts)

                    if not parser then
                        return
                    end

                    vim.treesitter.start(ev.buf, language)

                    vim.api.nvim_set_option_value("foldlevel", 99, {})
                    vim.api.nvim_set_option_value("foldlevelstart", 99, {})
                    vim.api.nvim_set_option_value("foldmethod", "expr", { scope = "local" })
                    vim.api.nvim_set_option_value("foldexpr", "v:lua.vim.treesitter.foldexpr()", { scope = "local" })
                    vim.api.nvim_set_option_value("foldtext", "", { scope = "local" })
                    vim.api.nvim_set_option_value("indentexpr", "v:lua.require('nvim-treesitter').indentexpr()", { scope = "local" })
                end,
            })
        end,
    },
}
