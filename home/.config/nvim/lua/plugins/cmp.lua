return {
    {
        "hrsh7th/cmp-omni",
        enabled = not vim.g.vscode,
    },

    {
        "hrsh7th/cmp-nvim-lsp",
        enabled = not vim.g.vscode,
    },

    {
        "hrsh7th/cmp-path",
        enabled = not vim.g.vscode,
    },

    {
        "hrsh7th/cmp-vsnip",
        enabled = not vim.g.vscode,
    },

    {
        "hrsh7th/cmp-cmdline",
        enabled = not vim.g.vscode,
    },

    {
        "hrsh7th/nvim-cmp",
        enabled = not vim.g.vscode,
        config = function()
            local cmp = require("cmp")

            cmp.setup.cmdline({ ":" }, {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "cmdline" },
                }),
            })

            cmp.setup({
                preselect = cmp.PreselectMode.None,
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            -- 選択されている項目を自動で入力しない
                            cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                        elseif vim.fn["vsnip#jumpable"](1) == 1 then
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-next)", true, true, true),
                                "",
                                false
                            )
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
                        elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                            vim.api.nvim_feedkeys(
                                vim.api.nvim_replace_termcodes("<Plug>(vsnip-jump-prev)", true, true, true),
                                "",
                                false
                            )
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<CR>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            if cmp.get_selected_entry() then
                                cmp.confirm()
                            else
                                fallback()
                            end
                        else
                            fallback()
                        end
                    end, { "i", "s" }),

                    ["<C-x><C-o>"] = cmp.mapping(function(_)
                        cmp.complete()
                    end, { "i" }),
                }),
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                formatting = {
                    format = function(_, vim_item)
                        local max_width = 50

                        if vim_item.abbr:len() > max_width then
                            vim_item.abbr = vim_item.abbr:sub(0, max_width) .. "..."
                        end
                        return vim_item
                    end,
                },
                sources = {
                    { name = "cmp-omni" },
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "vsnip" },
                },
                window = {
                    completion = {
                        border = "rounded",
                        col_offset = 0,
                        scrollbar = false,
                        scrolloff = 0,
                        side_padding = 1,
                        winblend = 0,
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:LspReferenceText,Search:None",
                    },
                    documentation = {
                        border = "rounded",
                        col_offset = 0,
                        scrollbar = false,
                        scrolloff = 0,
                        side_padding = 1,
                        winblend = 0,
                        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:LspReferenceText,Search:None",
                    },
                },
            })
        end,
    },
}
