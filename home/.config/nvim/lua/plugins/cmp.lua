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
        "hrsh7th/cmp-nvim-lsp-signature-help",
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

            cmp.setup.cmdline(":", {
                mapping = cmp.mapping.preset.cmdline(),
                sources = cmp.config.sources({
                    { name = "cmdline" },
                }),
            })

            cmp.setup({
                snippet = {
                    expand = function(args)
                        vim.fn["vsnip#anonymous"](args.body)
                    end,
                },
                window = {
                    completion = {
                        border = "rounded",
                        col_offset = 0,
                        scrollbar = false,
                        scrolloff = 0,
                        side_padding = 1,
                        winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:CursorLine,Search:None",
                    },
                    documentation = {
                        border = "rounded",
                        col_offset = 0,
                        scrollbar = false,
                        scrolloff = 0,
                        side_padding = 1,
                        winhighlight = "Normal:Normal,FloatBorder:Normal,CursorLine:CursorLine,Search:None",
                    },
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
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
                            cmp.select_prev_item()
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

                    ["<CR>"] = function(fallback)
                        if cmp.visible() then
                            if cmp.get_selected_entry() then
                                cmp.confirm()
                            else
                                fallback()
                            end
                        else
                            fallback()
                        end
                    end,
                }),
                sources = {
                    { name = "cmp-omni" },
                    { name = "nvim_lsp" },
                    { name = "nvim_lsp_signature_help" },
                    { name = "path" },
                    { name = "vsnip" },
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
            })
        end,
    },
}
