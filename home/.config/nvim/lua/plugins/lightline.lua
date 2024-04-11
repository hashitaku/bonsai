return {
    {
        "itchyny/lightline.vim",
        enabled = not vim.g.vscode,
        config = function()
            vim.cmd([[
            function! FileTypeIcon()
                return nerdfont#find() .. " " .. &filetype
            endfunction
            ]])

            vim.g.lightline = {
                colorscheme = "tokyonight",

                active = {
                    left = { { "mode", "paste" }, { "readonly", "filename", "modified" } },
                    right = { { "lineinfo" }, { "percent" }, { "fileformat", "fileencoding", "filetype" } },
                },

                component_function = {
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
