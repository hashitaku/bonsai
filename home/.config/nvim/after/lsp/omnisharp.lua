---@type vim.lsp.Config
return {
    cmd = {
        vim.fs.joinpath(vim.fn.stdpath("data"), "mason", "bin", "OmniSharp"),
        "-z",
        "--hostPID",
        tostring(vim.fn.getpid()),
        "DotNet:enablePackageRestore=false",
        "--encoding",
        "utf-8",
        "--languageserver",
    },
}
