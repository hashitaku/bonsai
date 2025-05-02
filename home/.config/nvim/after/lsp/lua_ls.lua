---@type vim.lsp.Config
return {
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
                unusedLocalExclude = { "_*" },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
        },
    },
}
