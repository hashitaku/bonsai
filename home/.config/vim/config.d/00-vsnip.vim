if !jetpack#tap("vim-vsnip")
    echoerr "config.d/00-vsnip.vim is not loading"
    finish
endif

let g:vsnip_snippet_dir = has("win32") ? expand("~/vimfiles/snippets") : expand("~/.vim/snippets")
