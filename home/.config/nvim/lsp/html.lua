---@type vim.lsp.Config
return {
    cmd = {
        "vscode-html-language-server",
        "--stdio",
    },
    filetypes = { "html", "templ" },
    root_markers = {
        "package.json",
        ".git",
    },
    capabilities = {
        textDocument = {
            completion = {
                completionItem = {
                    snippetSupport = true,
                },
            },
        },
    },
    init_options = {
        provideFormatter = true,
        embeddedLanguages = { css = true, javascript = true },
        configurationSection = { "html", "css", "javascript" },
    },
}
