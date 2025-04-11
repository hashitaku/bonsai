---@type vim.lsp.Config
return {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
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
}
