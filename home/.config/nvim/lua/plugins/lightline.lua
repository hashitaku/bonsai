return {
    {
        "itchyny/lightline.vim",
        enabled = not vim.g.vscode,
        config = function()
            vim.cmd([[
            function! FileTypeIcon()
                if &buftype ==# "terminal"
                    return nerdfont#find() .. " " .. "terminal"
                endif

                if empty(&filetype)
                    return "[No FileType]"
                endif

                return nerdfont#find() .. " " .. &filetype
            endfunction
            ]])

            vim.cmd([[
            function! FileName()
                if &buftype ==# "terminal"
                    return "terminal"
                endif

                if &buftype ==# "help"
                    return expand("%:t")
                endif

                if &filetype ==# "fern"
                    return "fern"
                endif

                if empty(bufname())
                    return "[No Name]"
                endif

                return bufname()
            endfunction
            ]])

            vim.g.lightline = {
                colorscheme = "tokyonight",

                active = {
                    left = { { "mode", "paste" }, { "readonly", "filename", "modified" } },
                    right = { { "lineinfo" }, { "percent" }, { "fileformat", "fileencoding", "filetype" } },
                },

                tabline = {
                    left = { { "tabs" } },
                    right = { { "close" } },
                },

                component_function = {
                    filename = "FileName",
                    filetype = "FileTypeIcon",
                },

                separator = { left = "\u{E0B4}", right = "\u{E0B6}" },
                subseparator = { left = "\u{E0B5}", right = "\u{E0B7}" },
                tabline_separator = { left = "\u{E0B4}", right = "\u{E0B6}" },
                tabline_subseparator = { left = "\u{E0B5}", right = "\u{E0B7}" },
            }
        end,
    },
}
