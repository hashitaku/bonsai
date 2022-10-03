if empty(globpath(&runtimepath, "autoload/lsp.vim"))
    finish
endif

let g:lsp_semantic_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_echo_delay = 250 
let g:lsp_inlay_hints_enabled = 1
let g:lsp_inlay_hints_delay = 100

hi link lspInlayHintsParameter Comment
hi link lspInlayHintsType Comment
