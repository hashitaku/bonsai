return {
    {
        "nvim-lualine/lualine.nvim",
        cond = not vim.g.vscode,
        dependencies = { "nvim-trek/nvim-web-devicons" },
        opts = {
            options = {
                component_separators = { left = "\u{E0B5}", right = "\u{E0B7}" },
                section_separators = { left = "\u{E0B4}", right = "\u{E0B6}" },
                always_show_tabline = false,
                globalstatus = true,
            },
            extensions = {
                "lazy",
                "mason",
                "oil",
                "quickfix",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "filename" },
                lualine_c = {},
                lualine_x = {
                    {
                        "fileformat",
                        symbols = {
                            dos = "dos",
                            mac = "mac",
                            unix = "unix",
                        },
                    },
                    {
                        "encoding",
                        show_bomb = true,
                    },
                    {
                        "filetype",
                    },
                },
                lualine_y = { "progress" },
                lualine_z = { "location" },
            },

            tabline = {
                lualine_a = {
                    {
                        "tabs",
                        mode = 2,
                        tabs_color = {
                            active = "TabLineSel",
                            inactive = "TabLine",
                        },
                    },
                },
                lualine_b = {},
                lualine_c = {},
                lualine_x = {},
                lualine_y = {},
                lualine_z = {},
            },
        },
    },
}
