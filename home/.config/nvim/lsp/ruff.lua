-- lua/config/lsp.luaのon_attach_handlerでhoverを無効化している
-- vim.lsp.Configでhoverを設定できるのであれば行いたい
---@type vim.lsp.Config
return {
    cmd = {
        "ruff",
        "server",
    },
    filetypes = { "python" },
    root_markers = {
        "pyproject.toml",
        "ruff.toml",
        ".ruff.toml",
        ".git",
    },
}
