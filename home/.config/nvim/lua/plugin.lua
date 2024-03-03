return {
    {
        "rcarriga/nvim-notify",
        enabled = not vim.g.vscode,
        opts = {
            fps = 120,
            render = "simple",
            stages = "slide",
        },
    },

    {
        "MunifTanjim/nui.nvim",
        enabled = not vim.g.vscode,
    },

    {
        "folke/flash.nvim",
        keys = {
            {
                "<Leader>f",
                mode = {
                    "n",
                },
                function()
                    require("flash").jump({
                        search = {
                            multi_window = false,
                            forward = true,
                            wrap = false,
                        },
                    })
                end,
            },

            {
                "<Leader>F",
                mode = {
                    "n",
                },
                function()
                    require("flash").jump({
                        search = {
                            multi_window = false,
                            forward = false,
                            wrap = false,
                        },
                    })
                end,
            },
        },
        opts = {
            modes = {
                search = {
                    enabled = false,
                },

                char = {
                    enabled = false,
                    jump_labels = true,
                },
            },
        },
    },

    {
        "folke/neodev.nvim",
        enabled = not vim.g.vscode,
    },

    {
        "folke/noice.nvim",
        enabled = not vim.g.vscode,
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            messages = {
                enabled = true,
                view = "notify",
            },
            presets = {
                command_palette = false,
            },
        },
    },

    {
        "folke/tokyonight.nvim",
        enabled = not vim.g.vscode,
    },

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

    {
        "hrsh7th/vim-vsnip",
        enabled = not vim.g.vscode,
        config = function()
            vim.g.vsnip_snippet_dir = vim.fn.stdpath("config") .. "/snippets"
        end,
    },

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

    {
        "lambdalisue/fern-git-status.vim",
        enabled = not vim.g.vscode,
        dependencies = {
            "lambdalisue/fern.vim",
        },
    },

    {
        "lambdalisue/fern-hijack.vim",
        enabled = not vim.g.vscode,
        dependencies = {
            "lambdalisue/fern.vim",
        },
    },

    {
        "lambdalisue/fern-renderer-nerdfont.vim",
        enabled = not vim.g.vscode,
        dependencies = {
            "lambdalisue/fern.vim",
            "lambdalisue/nerdfont.vim",
        },
    },

    {
        "lambdalisue/fern.vim",
        enabled = not vim.g.vscode,
        config = function()
            vim.g["fern#default_hidden"] = true
            vim.g["fern#drawer_keep"] = true
            vim.g["fern#renderer#nerdfont#indent_markers"] = true
            vim.g["fern#renderer#nerdfont#padding"] = " "
            vim.g["fern#renderer"] = "nerdfont"
            vim.keymap.set("n", "<C-n>", "<cmd>Fern . -reveal=% -drawer -toggle<cr>", {})

            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "fern" },
                callback = function()
                    vim.opt_local.number = false
                    vim.opt_local.relativenumber = false
                    vim.opt_local.signcolumn = "auto"
                end,
            })
        end,
    },

    {
        "lambdalisue/nerdfont.vim",
        enabled = not vim.g.vscode,
        config = function()
            vim.g["nerdfont#autofix_cellwidths"] = false
        end,
    },

    {
        "neovim/nvim-lspconfig",
        enabled = not vim.g.vscode,
        config = function()
            local lspconfig = require("lspconfig")

            require("lspconfig.ui.windows").default_options.border = "rounded"

            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

            local user_lsp_augid = vim.api.nvim_create_augroup("user_lsp", {})
            local on_attach_handler = function(client, bufnr)
                if client.supports_method("textDocument/documentHighlight") then
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = bufnr,
                        group = user_lsp_augid,
                        callback = function()
                            vim.lsp.buf.document_highlight()
                        end,
                    })

                    vim.api.nvim_create_autocmd("CursorMoved", {
                        buffer = bufnr,
                        group = user_lsp_augid,
                        callback = function()
                            vim.lsp.buf.clear_references()
                        end,
                    })
                end
            end

            lspconfig["clangd"].setup({
                cmd = {
                    "clangd",
                    "--clang-tidy",
                    "--header-insertion=never",
                    "-j=2",
                },
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            lspconfig["rust_analyzer"].setup({
                cmd = {
                    "rust-analyzer",
                },
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            lspconfig["slint_lsp"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            lspconfig["lua_ls"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
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

            lspconfig["ruff_lsp"].setup({
                handlers = vim.lsp.handlers,
                on_attach = function(client, bufnr)
                    client.server_capabilities.hoverProvider = false
                    on_attach_handler(client, bufnr)
                end,
                init_options = {
                    settings = {
                        args = {},
                    },
                },
            })

            lspconfig["pyright"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            lspconfig["omnisharp"].setup({
                cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            local html_css_capabilities = vim.lsp.protocol.make_client_capabilities()
            html_css_capabilities.textDocument.completion.completionItem.snippetSupport = true
            lspconfig["html"].setup({
                cmd = {
                    "npx",
                    "vscode-html-language-server",
                    "--stdio",
                },
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                capabilities = html_css_capabilities,
            })

            lspconfig["cssls"].setup({
                cmd = {
                    "npx",
                    "vscode-css-language-server",
                    "--stdio",
                },
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                capabilities = html_css_capabilities,
            })

            lspconfig["denols"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
            })

            lspconfig["tsserver"].setup({
                cmd = {
                    "npx",
                    "typescript-language-server",
                    "--stdio",
                },
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                root_dir = lspconfig.util.root_pattern("package.json"),
            })

            local angularls_cmd = {
                "npx",
                "ngserver",
                "--stdio",
                "--tsProbeLocations",
                " ",
                "--ngProbeLocations",
                " ",
            }
            lspconfig["angularls"].setup({
                cmd = angularls_cmd,
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                on_new_config = function(new_config, new_root_dir)
                    new_config.cmd = angularls_cmd
                end,
            })
        end,
    },

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

    {
        "rust-lang/rust.vim",
        enabled = not vim.g.vscode,
        ft = "rust",
        config = function()
            vim.g.rustfmt_autosave = true
        end,
    },

    {
        "slint-ui/vim-slint",
        enabled = not vim.g.vscode,
    },

    {
        "windwp/nvim-autopairs",
        enabled = not vim.g.vscode,
        opts = {},
    },

    {
        "lukas-reineke/indent-blankline.nvim",
        enabled = not vim.g.vscode,
        main = "ibl",
        opts = {},
    },

    {
        "hashitaku/chester.nvim",
        branch = "develop",
        enabled = not vim.g.vscode,
    },
}
