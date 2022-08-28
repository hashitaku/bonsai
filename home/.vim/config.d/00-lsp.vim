if empty(globpath(&runtimepath, "autoload/lsp.vim"))
    finish
endif

let g:lsp_semantic_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
