return {
    {
        "neovim/nvim-lspconfig",
        enabled = not vim.g.vscode,
        config = function()
            local lspconfig = require("lspconfig")

            -- neovim 0.11.0以降はvim.lsp.buf.hoverの引数で設定する
            if vim.version.lt(vim.version(), "0.11.0-beta") then
                vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { border = "rounded" })
            end

            vim.lsp.handlers["textDocument/signatureHelp"] =
                vim.lsp.with(vim.lsp.handlers.signature_help, { border = "rounded" })

            local user_lsp_augid = vim.api.nvim_create_augroup("user_lsp", {})
            ---@param client vim.lsp.Client
            ---@param bufnr integer
            local on_attach_handler = function(client, bufnr)
                if vim.version.ge(vim.version(), "0.11.0-beta") then
                    if client.supports_method("textDocument/hover") then
                        vim.keymap.set("n", "K", function()
                            vim.lsp.buf.hover({})
                        end, { buffer = bufnr })
                    end
                end

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

                if
                    client.supports_method("textDocument/formatting")
                    and vim.list_contains({ "rust_analyzer", "ruff" }, client.name)
                then
                    vim.api.nvim_create_autocmd({ "BufWritePre" }, {
                        buffer = bufnr,
                        group = user_lsp_augid,
                        callback = function()
                            vim.lsp.buf.format({
                                async = false,
                            })
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

            lspconfig["mesonlsp"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            lspconfig["rust_analyzer"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                settings = {
                    ["rust-analyzer"] = {
                        check = {
                            command = "clippy",
                        },
                    },
                },
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

            lspconfig["ruff"].setup({
                handlers = vim.lsp.handlers,
                on_attach = function(client, bufnr)
                    client.server_capabilities.hoverProvider = false
                    on_attach_handler(client, bufnr)
                end,
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

            lspconfig["gopls"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            local html_css_capabilities = vim.lsp.protocol.make_client_capabilities()
            html_css_capabilities.textDocument.completion.completionItem.snippetSupport = true
            lspconfig["html"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                capabilities = html_css_capabilities,
            })

            lspconfig["cssls"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                capabilities = html_css_capabilities,
            })

            lspconfig["denols"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                root_dir = lspconfig.util.root_pattern("deno.json", "deno.jsonc"),
            })

            lspconfig["ts_ls"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                root_dir = lspconfig.util.root_pattern("package.json"),
            })

            lspconfig["angularls"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            lspconfig["tinymist"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
                single_file_support = true,
            })

            lspconfig["taplo"].setup({
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })

            lspconfig["powershell_es"].setup({
                bundle_path = vim.fs.joinpath(vim.fn.stdpath("data"), "mason/packages/powershell-editor-services"),
                handlers = vim.lsp.handlers,
                on_attach = on_attach_handler,
            })
        end,
    },
}
