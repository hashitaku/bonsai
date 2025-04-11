---@type vim.lsp.Config
return {
    cmd = {
        "slint_lsp",
    },
    filetypes = { "slint" },
    root_markers = {
        ".git",
    },
}
