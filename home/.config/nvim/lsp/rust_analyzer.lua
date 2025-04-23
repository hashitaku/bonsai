---@type vim.lsp.Config
return {
    cmd = {
        "rust-analyzer",
    },
    filetypes = { "rust" },
    root_markers = {
        "Carto.toml",
    },
    settings = {
        ["rust-analyzer"] = {
            check = {
                command = "clippy",
            },
        },
    },
}
