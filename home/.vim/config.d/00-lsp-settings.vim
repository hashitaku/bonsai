if empty(globpath(&runtimepath, "autoload/lsp-settings.vim"))
    finish
endif

set g:lsp_settings = {
\   'clangd': {'cmd': ['clangd', '--malloc-trim' '-j=2', '--clang-tidy']},
\}
