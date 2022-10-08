function s:imap_tab()
    if pumvisible()
        return "\<C-n>"
    elseif vsnip#jumpable(1)
        return "\<Plug>(vsnip-jump-next)"
    else
        return "\<Tab>"
    endif
endfunction

function s:imap_stab()
    if pumvisible()
        return "\<C-p>"
    elseif vsnip#jumpable(-1)
        return "\<Plug>(vsnip-jump-prev)"
    else
        return "\<S-Tab>"
    endif
endfunction

imap <expr> <tab>   <SID>imap_tab()
imap <expr> <S-Tab> <SID>imap_stab()
imap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

nnoremap <C-n> <cmd>Fern . -reveal=% -drawer -toggle<cr>

inoremap [ []<LEFT>
inoremap { {}<LEFT>
inoremap ( ()<LEFT>
inoremap ' ''<LEFT>
inoremap " ""<LEFT>
