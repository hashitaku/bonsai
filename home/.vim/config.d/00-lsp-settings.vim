if empty(globpath(&runtimepath, "autoload/lsp_settings.vim"))
    finish
endif

let g:lsp_settings_filetype_typescript = ["typescript-language-server", "deno"]

let g:lsp_settings = {
\   "clangd": {"cmd": ["clangd", "--malloc-trim", "-j=2", "--clang-tidy"]},
\}
