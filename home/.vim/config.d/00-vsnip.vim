if empty(globpath(&runtimepath, "autoload/vsnip.vim"))
    finish
endif

let g:vsnip_snippet_dir = has("win32") ? expand("~/vimfiles/snippets") : expand("~/.vim/snippets")
