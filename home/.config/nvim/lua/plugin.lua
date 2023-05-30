return {
    {
        "MunifTanjim/nui.nvim",
    },

    {
        "folke/noice.nvim",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        cond = true,
        opts = {
            message = {
                enabled = false,
            },
            preests = {
                command_palette = false,
            },
        },
    },

    {
        "folke/tokyonight.nvim",
    },

    {
        "hrsh7th/cmp-nvim-lsp",
    },

    {
        "hrsh7th/cmp-path",
    },

    {
        "hrsh7th/cmp-vsnip",
    },

    {
        "hrsh7th/cmp-cmdline",
    },

    {
        "hrsh7th/nvim-cmp",
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
                            cmp.confirm()
                        else
                            fallback()
                        end
                    end,
                }),
                sources = cmp.config.sources({
                    { name = "nvim_lsp" },
                    { name = "path" },
                    { name = "vsnip" },
                }),
                formatting = {
                    format = function(entry, vim_item)
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

    {
        "hrsh7th/vim-vsnip",
        config = function()
            vim.g["vsnip_snippet_dir"] = vim.fn.stdpath("config") .. "/snippets"
        end,
    },

    {
        "itchyny/lightline.vim",
        cond = false,
        config = function()
            vim.g["lightline"] = {
                colorscheme = "one",

                active = {
                    left = { { "mode", "paste" }, { "readonly", "filename", "modified" } },
                    right = { { "lineinfo" }, { "percent" }, { "fileformat", "fileencoding", "filetype" } },
                },

                separator = { left = "\u{E0B4}", right = "\u{E0B6}" },
                subseparator = { left = "\u{E0B5}", right = "\u{E0B7}" },
                tabline_separator = { left = "\u{E0B4}", right = "\u{E0B6}" },
                tabline_subseparator = { left = "\u{E0B5}", right = "\u{E0B7}" },
            }
        end,
    },

    {
        "nvim-lualine/lualine.nvim",
        cond = true,
        opts = {
            options = {
                theme = "tokyonight",
                component_separators = { left = "\u{E0B5}", right = "\u{E0B7}" },
                section_separators = { left = "\u{E0B4}", right = "\u{E0B6}" },
            },
            sections = {
                lualine_a = {
                    {
                        "mode",
                        separator = {
                            left = "\u{E0B6}",
                            right = "\u{E0B4}",
                        },
                        right_padding = 2,
                    },
                },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = {},
                lualine_x = { "encoding", "fileformat", "filetype" },
                lualine_y = { "progress" },
                lualine_z = {
                    {
                        "location",
                        separator = {
                            left = "\u{E0B6}",
                            right = "\u{E0B4}",
                        },
                    },
                },
            },
            --tabline = {
            --    lualine_a = {
            --        'navic',
            --        color_correction = nil,
            --        navic_opts = nil,
            --    },
            --},
        },
    },

    {
        "lambdalisue/fern-git-status.vim",
        dependencies = {
            "lambdalisue/fern.vim",
        },
    },

    {
        "lambdalisue/fern-hijack.vim",
        dependencies = {
            "lambdalisue/fern.vim",
        },
    },

    {
        "lambdalisue/fern-renderer-nerdfont.vim",
        dependencies = {
            "lambdalisue/fern.vim",
        },
    },

    {
        "lambdalisue/fern.vim",
        config = function()
            vim.g["fern#default_hidden"] = true
            vim.g["fern#drawer_keep"] = true
            vim.g["fern#renderer#nerdfont#indent_markers"] = true
            vim.g["fern#renderer"] = "nerdfont"
            vim.api.nvim_set_keymap("n", "<C-n>", "<cmd>Fern . -reveal=% -drawer -toggle<cr>", { noremap = true })

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "fern" },
                callback = function()
                    vim.opt_local["number"] = false
                    vim.opt_local["signcolumn"] = "auto"
                end,
            })
        end,
    },

    {
        "lambdalisue/nerdfont.vim",
    },

    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "SmiteshP/nvim-navic",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local navic = require("nvim-navic")
            require("lspconfig.ui.windows").default_options.border = "rounded"

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

            vim.api.nvim_create_user_command("LspHover", function(args)
                vim.lsp.buf.hover()
            end, {
                nargs = "?",
            })

            vim.opt["keywordprg"] = ":LspHover"

            lspconfig["clangd"].setup({
                cmd = {
                    "clangd",
                    "--clang-tidy",
                    "--header-insertion=never",
                    "--malloc-trim",
                    "-j=2",
                },
                handlers = vim.lsp.handlers,
            })

            lspconfig["rust_analyzer"].setup({
                handlers = vim.lsp.handlers,
            })

            lspconfig["lua_ls"].setup({
                on_attach = function(client, bufnr)
                    navic.attach(client, bufnr)
                end,
                handlers = vim.lsp.handlers,
                settings = {
                    Lua = {
                        runtime = {
                            version = "LuaJIT",
                        },
                        diagnostics = {
                            globals = { "vim" },
                        },
                        workspace = {
                            library = vim.api.nvim_get_runtime_file("", true),
                            checkThirdParty = false,
                        },
                    },
                },
            })

            lspconfig["denols"].setup({
                root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
                handlers = vim.lsp.handlers,
            })

            lspconfig["tsserver"].setup({
                root_dir = lspconfig.util.root_pattern("package.json"),
                handlers = vim.lsp.handlers,
            })
        end,
    },

    {
        "nvim-treesitter/nvim-treesitter",
        main = "nvim-treesitter.configs",
        opts = {
            ensure_installed = {
                "bash",
                "c",
                "cmake",
                "cpp",
                "vimdoc",
                "json",
                "lua",
                "make",
                "markdown",
                "markdown_inline",
                "meson",
                "python",
                "regex",
                "rust",
                "typescript",
                "vim",
            },
            sync_intall = true,
            highlight = {
                enable = true,
            },
        },
    },

    {
        "nvim-treesitter/nvim-treesitter-context",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },

    {
        "nvim-treesitter/playground",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
        },
    },

    {
        "rust-lang/rust.vim",
        ft = "rust",
        config = function()
            vim.g["rustfmt_autosave"] = true
        end,
    },

    {
        "windwp/nvim-autopairs",
        opts = {},
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        opts = {
            char = "",
            show_current_context = true,
            --use_treesitter = true,
            --show_current_context_start = true,
        },
    },

    {
        "nvim-lua/plenary.nvim",
    },

    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = {},
    },

    {
        "nvim-tree/nvim-web-devicons",
    },

    {
        "ggandor/leap.nvim",
        opts = {},
    },

    {
        "SmiteshP/nvim-navic",
        opts = {},
    },

    {
        "utilyre/barbecue.nvim",
        dependencies = {
            "SmiteshP/nvim-navic",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("barbecue").setup()
        end,
    },

    {
        "hashitaku/chester.nvim",
        branch = "develop",
    },
}
