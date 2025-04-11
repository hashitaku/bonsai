---@type vim.lsp.Config
return {
    cmd = {
        "clangd",
        "--clang-tidy",
        "--header-insertion=never",
        "-j=2",
    },
    filetypes = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
    root_markers = {
        ".clangd",
        ".clang-tidy",
        ".clang-format",
        "compile_commands.json",
        "compile_flags.txt",
        "configure.ac",
    },
}
