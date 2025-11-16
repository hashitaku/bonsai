---@type vim.lsp.Config
return {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--header-insertion=never",
        "-j=2",
    },
}
