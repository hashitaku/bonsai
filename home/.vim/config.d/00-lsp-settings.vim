if !jetpack#tap("vim-lsp-settings")
    echoerr "config.d/00-lsp-settings.vim is not loading"
    finish
endif

let g:lsp_settings_filetype_typescript = ["typescript-language-server", "deno"]

let g:lsp_settings = {
\   "clangd": {"cmd": ["clangd", "--malloc-trim", "-j=2", "--clang-tidy", "--header-insertion=never"]},
\}
