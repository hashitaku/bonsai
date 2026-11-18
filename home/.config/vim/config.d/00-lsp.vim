if !jetpack#tap("vim-lsp")
    echoerr "config.d/00-lsp.vim is not loading"
    finish
endif

let &keywordprg = ":LspHover"
let &tagfunc = "lsp#tagfunc"

let g:lsp_semantic_enabled = 1
let g:lsp_diagnostics_enabled = 1
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_diagnostics_echo_delay = 250 
let g:lsp_inlay_hints_enabled = 1
let g:lsp_inlay_hints_delay = 100
