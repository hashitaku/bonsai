---@type vim.lsp.Config
return {
    cmd = {
        "omnisharp",
        "--languageserver",
        "--encoding",
        "utf-8",
        "--hostPID",
        tostring(vim.fn.getpid()),
    },
    filetypes = { "cs", "vb" },
    root_markers = {
        "*.sln",
        "*.csproj",
        "omnisharp.json",
        "function.json",
    },
    settings = {
        FormattingOptions = {
            EnableEditorConfigSupport = true,
            OrganizeImports = nil,
        },
        MsBuild = {
            LoadProjectsOnDemand = true,
        },
        RoslynExtensionsOptions = {
            EnableAnalyzersSupport = true,
            EnableImportCompletion = true,
            AnalyzeOpenDocumentsOnly = true,
        },
        Sdk = {
            IncludePrereleases = false,
        },
    },
}
