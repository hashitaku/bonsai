if vim.g.vscode then
    return
end

local lsp_signature = require("lsp_signature")
local cmp_nvim_lsp = require("cmp_nvim_lsp")
local user_lsp_augid = vim.api.nvim_create_augroup("user_lsp", { clear = false })

vim.api.nvim_create_autocmd("LspAttach", {
    group = user_lsp_augid,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        local bufnr = args.buf

        if client then
            if client:supports_method("textDocument/hover", bufnr) then
                vim.keymap.set("n", "K", function()
                    vim.lsp.buf.hover({ border = "rounded" })
                end, { buffer = bufnr, desc = "vim.lsp.buf.hover()" })
            end

            if client:supports_method("textDocument/signatureHelp", bufnr) then
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

            vim.keymap.set("n", "<Leader>v", function()
                if client:supports_method("textDocument/inlayHint", bufnr) then
                    vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }), { bufnr = bufnr })
                else
                    vim.notify("Inlay hints not supported by the LSP server", vim.log.levels.WARN)
                end
            end, { buffer = bufnr, desc = "Toggle Inlay Hint" })

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

vim.lsp.config("*", {
    capabilities = cmp_nvim_lsp.default_capabilities(),
})

vim.lsp.enable({
    "angularls",
    "clangd",
    "cssls",
    "denols",
    "gopls",
    "html",
    "lua_ls",
    "mesonlsp",
    "omnisharp",
    "powershell_es",
    "pyright",
    "ruff",
    "rust_analyzer",
    "slint_lsp",
    "taplo",
    "tinymist",
    "ts_ls",
})
