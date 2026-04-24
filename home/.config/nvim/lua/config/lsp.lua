if vim.g.vscode then
    return
end

local user_lsp_augid = vim.api.nvim_create_augroup("user_lsp", { clear = false })

vim.api.nvim_create_autocmd("LspAttach", {
    group = user_lsp_augid,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        if client then
            -- omnisharpはserver_capabilitiesを正しく出力していない？
            if client:supports_method("textDocument/hover", bufnr) or client.name == "omnisharp" then
                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover({ border = "rounded" })
                end, { buffer = bufnr, desc = "vim.lsp.buf.hover()" })
            end

            if client:supports_method("textDocument/inlayHint", bufnr) then
                vim.keymap.set("n", "<Leader>v", function()
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                end, { buffer = bufnr, desc = "Toggle Inlay Hint" })
            end

            if client:supports_method("textDocument/inlineCompletion", bufnr) then
                vim.lsp.inline_completion.enable(true, {})

                vim.keymap.set("i", "<M-l>", function()
                    vim.lsp.inline_completion.get({ bufnr = bufnr })
                end, { buffer = bufnr, desc = "Select Inline Completion" })
            end

            local result, lsp_signature = pcall(require, "lsp_signature")
            if result and client:supports_method("textDocument/signatureHelp", bufnr) then
                lsp_signature.on_attach({}, bufnr)
            end

            if client:supports_method("textDocument/documentHighlight", bufnr) then
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

            if
                client:supports_method("textDocument/formatting", bufnr)
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

            if client.name == "ruff" then
                client.server_capabilities.hoverProvider = false
            end
        end
    end,
})

local result, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if result then
    vim.lsp.config("*", {
        capabilities = cmp_nvim_lsp.default_capabilities(),
    })
end

vim.lsp.enable({
    "angularls",
    "clangd",
    "copilot",
    "cssls",
    "denols",
    "gopls",
    "html",
    "lua_ls",
    "omnisharp",
    "powershell_es",
    "pyright",
    "ruff",
    "rust_analyzer",
    "taplo",
    "tinymist",
    "ts_ls",
})
