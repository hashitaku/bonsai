---@param client vim.lsp.Client
---@param bufnr integer
local on_attach_handler = function(client, bufnr)
    local lsp_signature = require("lsp_signature")
    local user_lsp_augid = vim.api.nvim_create_augroup("user_lsp", { clear = false })

    if client:supports_method("textDocument/hover", bufnr) then
        vim.keymap.set("n", "K", function()
            vim.lsp.buf.hover({ border = "rounded" })
        end, { buffer = bufnr })
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

    if client:supports_method("textDocument/inlayHint", bufnr) then
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

vim.api.nvim_create_user_command("LspInfo", "checkhealth vim.lsp", {})

vim.lsp.config("*", {
    on_attach = on_attach_handler,
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
