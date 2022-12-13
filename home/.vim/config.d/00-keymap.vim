def s:imap_tab(): string
    if pumvisible()
        return "\<C-n>"
    elseif vsnip#jumpable(1)
        return "\<Plug>(vsnip-jump-next)"
    else
        return "\<Tab>"
    endif
enddef

def s:imap_stab(): string
    if pumvisible()
        return "\<C-p>"
    elseif vsnip#jumpable(-1)
        return "\<Plug>(vsnip-jump-prev)"
    else
        return "\<S-Tab>"
    endif
enddef

let s:comment_out_chars = {
\   "vim" : "\" ",
\   "c"   : "// ",
\   "cpp" : "// ",
\   "rust": "// ",
\}

def s:toggle_comment_out(ft: string)
    var line = substitute(getline("."), "^\\s\\+", "", "")
    var chars = get(s:comment_out_chars, ft, "")
    var cur = getcurpos()

    if line[0 : len(chars) - 1] == chars
        execute("substitute " .. printf("#%s##", chars))
        cur[2] -= len(chars)
    else
        cur[2] += len(chars)
        execute("substitute " .. printf("#\\<#%s#", chars))
    endif

    setpos(".", cur)
enddef

nnoremap <silent> <C-_> <cmd>call <SID>toggle_comment_out(&ft)<cr>
nnoremap          <C-k> <cmd>term ++close ++rows=10<cr>

imap <expr> <tab>   <SID>imap_tab()
imap <expr> <S-Tab> <SID>imap_stab()
imap <expr> <cr>    pumvisible() ? "\<C-y>" : "\<cr>"

if has("gui_running")
    nnoremap <C-n> <cmd>Fern %:h -reveal=% -drawer -toggle<cr>
else
    nnoremap <C-n> <cmd>Fern . -reveal=% -drawer -toggle<cr>
endif
