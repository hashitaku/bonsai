return {
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

                if client.supports_method("textDocument/references") then
                    vim.keymap.set("n", "gr", vim.lsp.buf.references, { buffer = bufnr })
                end

                if client.supports_method("textDocument/inlayHint") then
                    vim.api.nvim_create_autocmd({ "InsertEnter" }, {
                        buffer = bufnr,
                        group = user_lsp_augid,
                        callback = function()
                            vim.lsp.inlay_hint.enable(false, { bufnr = bufnr })
                        end,
                    })

                    vim.api.nvim_create_autocmd({ "InsertLeave" }, {
                        buffer = bufnr,
                        group = user_lsp_augid,
                        callback = function()
                            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
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
}
