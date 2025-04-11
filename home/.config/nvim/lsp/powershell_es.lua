---@type vim.lsp.Config
return {
    cmd = {
        vim.fs.joinpath(vim.fn.stdpath("data"), "mason/packages/powershell-editor-services"),
    },
    filetypes = { "ps1" },
    root_markers = {
        "PSScriptAnalyzerSettings.psd1",
        ".git",
    },
}
